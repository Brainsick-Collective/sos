extends Node2D
class_name CombatArena

var fighter1
var fighter2
var choice1
var choice2
var fighter1chose
var fighter2chose
var isfighter1First
var round_num = 0
var is_round_over = false
var is_battle_over = false
var notifications = []
var battle_notes = []
var note_q
var tween_to_reverse
var exiting = false
enum move_types { empty = -1, normal, special, magic, effect }
onready var Notification = preload("res://interface/UI/notification.tscn")
onready var BoardNotification = preload("res://interface/UI/BoardNotification.tscn")
onready var phase_handler = $CombatPhaseHandler

signal transitioning
signal completed (notifications)

const choices =[
    "ui_down",
    "ui_left",
    "ui_right",
    "ui_up"
]

const choice_map = {"ui_left" : move_types.normal,
                    "ui_right" : move_types.special,
                    "ui_up" : move_types.magic,
                    "ui_down" : move_types.effect}
    
func initialize(_player):
    fighter1.connect("killed", self, "on_won_battle", [], CONNECT_DEFERRED)
    fighter2.connect("killed", self, "on_won_battle", [], CONNECT_DEFERRED)
    fighter1.stats.connect("leveled_up", self, "add_notification", [], CONNECT_DEFERRED)
    fighter2.stats.connect("leveled_up", self, "add_notification", [], CONNECT_DEFERRED)
    fighter1chose = false
    fighter2chose = false
    $"1".add_child(fighter1)
    $UI/GUI/Combatant1Panel.set_actor(fighter1)
    $UI/GUI/Combatant2Panel.set_actor(fighter2)
    $"2".add_child(fighter2)
    fighter2.flip_sprite()
    fighter1.set_target($"2")
    fighter2.set_target($"1")
    $MatchupInterface.initialize(fighter1, fighter2)
    $UI/CombatInterface.initialize(fighter1, fighter2)
# warning-ignore:return_value_discarded
    $UI/CombatInterface/TurnOrderPopup.connect("hide", self, "on_turnorder_popup_hide", [], CONNECT_DEFERRED)
# warning-ignore:return_value_discarded
    $UI/CombatInterface/TurnOrderPopup.connect("chosen", self, "on_choice", [], CONNECT_DEFERRED)
    $UI/CombatInterface.decide_turns()
    set_process_input(false)
    
func setup(f1: Combatant, f2 : Combatant):
    fighter1 = f1
    fighter2 = f2




func _process(_delta):
    check_ready()
    
    
func check_ready():
    if is_battle_over:
        return
    if fighter2 is Mob and fighter1chose:
        choice2 = move_types.normal
        fighter2chose = true
    if fighter1chose and fighter2chose:
        set_process_input(false)
        print("players have chosen their moves")
        if isfighter1First:
            do_phase(fighter1, fighter2, fighter1.get_move(choice1, true), fighter2.get_move(choice2, false))
        else:
            do_phase(fighter2, fighter1, fighter2.get_move(choice2, true), fighter1.get_move(choice1, false))
    

func do_phase(attacker, defender, attacker_move, defender_move):
    if defender_move.type == move_types.effect:
        on_give_up(defender.player)
        return

    fighter1chose = false
    fighter2chose = false
    phase_handler.do_phase(attacker, defender, attacker_move, defender_move)
    yield(phase_handler, "phase_completed")

    round_num += 1
    
    if round_num % 2 == 1:
        isfighter1First = !isfighter1First
        $UI/CombatInterface.do_combat_phase(isfighter1First)
        set_process_input(true)
        $MatchupInterface.set_predictions(defender)
    elif not exiting:
        _exit_transition()

func _input(event):
    for key in choices:
        if !fighter1chose and event.is_action_pressed(key + String(fighter1.get_id())):
            choice1 = choice_map[key]
            fighter1chose = true
        elif !fighter2chose and !fighter2 is Mob and event.is_action_pressed(key + String(fighter2.get_id())):
            choice2 = choice_map[key]
            fighter2chose = true

func on_choice(choice):
    isfighter1First = choice
    var attacker
    if isfighter1First:
        attacker = fighter1
    else:
        attacker = fighter2
    $MatchupInterface.set_predictions(attacker)

func on_turnorder_popup_hide():
    set_process_input(true)
    
func on_won_battle(killed, reward):
    exiting = true
    
    var winner : Combatant
    if killed == fighter1:
        winner = fighter2
    else:
        winner = fighter1
    if winner is Mob:
        winner = null
    if winner:
        winner.player.receive_item(reward)
        if reward:
            var reward_note = Notification.instance()
            reward_note.initialize(null,null, winner.actor_name + "received " + reward.name + "!")
            battle_notes.push_front(reward_note)
        winner.stats.set_xp(winner.stats.get_xp() + killed.stats.kill_xp)
        var b_note = Notification.instance()
        b_note.initialize(null, null, winner.actor_name + " won!")
        battle_notes.push_front(b_note)

    set_process_input(false)
    is_battle_over = true
    
    var kill_desc = killed.actor_name + " has been killed!"
    print(kill_desc)
    
    

    
    if !(killed is Mob):
        var note = BoardNotification.instance()
        note.initialize(killed.player, null, killed.actor_name + " is dead!")
        notifications.append(note)
    else:
        if killed.defeated_trigger:
            get_parent().queue_cutscene(killed.get_cutscene_trigger())
            
    _exit_transition()

func on_give_up(retiree):
    exiting = true
    set_process_input(false)
    is_battle_over = true
#    $UI/GUI/Choices.text = retiree.player_name + " has given up!"
    print(retiree.player_name + " has given up!")
    $UI/CombatInterface.queue_free()

    var note = Notification.instance()
    note.initialize(retiree, null, retiree.player_name + " is in timeout!")
    notifications.append(note) 
    _exit_transition()

func switch_fighters(fighter):
    if fighter == fighter1:
        return
    else:
        $"2".remove_child(fighter2)
        $"1".add_child(fighter2)
        $"1".remove_child(fighter1)
        $"2".add_child(fighter1)
        fighter2 = fighter1
        fighter1 = fighter
        fighter2.flip_sprite()
        $UI/GUI/Combatant1Panel.set_actor(fighter1)
        $UI/GUI/Combatant2Panel.set_actor(fighter2)

func dealloc():
    fighter1.player.in_battle = !is_battle_over
    fighter2.player.in_battle = !is_battle_over
    fighter2.flip_sprite()
    
#    if !is_battle_over:
        #tell mob pawn to delete self

    $"1".remove_child(fighter1)
    $"2".remove_child(fighter2)
    queue_free()

func get_mob():
    if fighter2 is Mob:
        return fighter2
        
func _exit_transition():
    $UI/CombatInterface.hide()
    if not battle_notes.empty():
        var note = battle_notes.pop_front()
        $UI/NoteContainer.show()
        $UI/NoteContainer.add_child(note)
        note.popup()
        yield(note, "tree_exited")
        print("nonsense")
        var timer = Timer.new()
        timer.one_shot = true
        add_child(timer)
        timer.start(0.4)
        yield(timer, "timeout")
        call_deferred("_exit_transition")
    else:
        _exit()

func _exit():
    print("exiting")
    $Timer.set_wait_time(1)
    $Timer.start()
    get_parent().play_transition()
    
func _on_Timer_timeout():
    dealloc()
    emit_signal("completed", notifications)
    
func get_fighters():
    return [fighter1, fighter2]

func add_notification(note):
    battle_notes.append(note)
    
func _on_CombatArena_tree_entered():
    set_process_input(false)
    $AnimationPlayer.play("slide in")
    if round_num > 0:
        $UI/CombatInterface.decide_turns()
