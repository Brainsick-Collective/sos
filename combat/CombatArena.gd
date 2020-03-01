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
var note_q
var tween_to_reverse
enum move_types { empty = -1, normal, special, magic, effect }
onready var Notification = preload("res://interface/UI/notification.tscn")
onready var BoardNotification = preload("res://interface/UI/BoardNotification.tscn")

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
    fighter1.connect("killed", self, "on_won_battle")
    fighter2.connect("killed", self, "on_won_battle")
    fighter1.stats.connect("leveled_up", self, "play_notification")
    fighter2.stats.connect("leveled_up", self, "play_notification")
    fighter1chose = false
    fighter2chose = false
    $"1".add_child(fighter1)
    $UI/GUI/Combatant1Panel.set_actor(fighter1)
    $UI/GUI/Combatant2Panel.set_actor(fighter2)
    $"2".add_child(fighter2)
    fighter2.flip_sprite()
    $MatchupInterface.initialize(fighter1, fighter2)
    $UI/CombatInterface.initialize(fighter1, fighter2)
# warning-ignore:return_value_discarded
    $UI/CombatInterface/TurnOrderPopup.connect("hide", self, "on_turnorder_popup_hide")
# warning-ignore:return_value_discarded
    $UI/CombatInterface/TurnOrderPopup.connect("chosen", self, "on_choice")
    $UI/CombatInterface.decide_turns()
    set_process_input(false)
    
func set_fighters(f1, f2):
    fighter1 = f1
    fighter2 = f2

func _process(_delta):
    check_ready()
    
    
func check_ready():
    if is_battle_over:
        return
    if fighter2.is_mob() and fighter1chose:
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
    var hit = attacker_move.execute(defender,defender_move)
    round_num += 1
        #add that defender_move  animation still plays
    fighter1chose = false
    fighter2chose = false
    # TODO change this to be from a gave_up signal
    if defender_move.type == move_types.effect:
        on_give_up(defender.player)
        return
    if hit:
        # TODO externalize this to the combatant, with a "target" 2d pos
        # who will get details from the action
        var curr_pos = attacker.get_parent().position
        attacker.tween.interpolate_property(attacker.get_parent(), "position",
            attacker.get_parent().position, defender.get_parent().position, 
            0.5 , Tween.TRANS_LINEAR, Tween.EASE_IN) 
        attacker.tween.start()
        yield(attacker.tween, "tween_completed")
        attacker.tween.interpolate_property(attacker.get_parent(), "position",
            defender.get_parent().position, curr_pos, 
            1.0 , Tween.TRANS_LINEAR, Tween.EASE_IN)
        attacker.tween.start()
        hit.execute()
        yield(attacker.tween, "tween_completed")
       
#        attacker.tween.connect("tween_completed", self, "reverse_tween")
#        tween_to_reverse = attacker.tween
    if round_num % 2 == 1:
        isfighter1First = !isfighter1First
        $UI/CombatInterface.do_combat_phase(isfighter1First)
        set_process_input(true)
        $MatchupInterface.set_predictions(defender)
    else:
        $Timer.set_wait_time(2)
        $Timer.start()

func _input(event):
    for key in choices:
        if !fighter1chose and event.is_action_pressed(key + String(fighter1.get_id())):
            choice1 = choice_map[key]
            fighter1chose = true
        elif !fighter2chose and !fighter2.is_mob() and event.is_action_pressed(key + String(fighter2.get_id())):
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
    var winner : Combatant
    if killed == fighter1:
        winner = fighter2
    else:
        winner = fighter1
    if winner is Mob:
        winner = null
    if winner:
        winner.player.receive_item(reward)
        winner.stats.set_xp(winner.stats.get_xp() + killed.stats.kill_xp)
    
    set_process_input(false)
    is_battle_over = true
    
    #do a notification in combatArena
    var kill_desc = killed.actor_name + " has been killed!"
    print(kill_desc)
    
    $Timer.set_wait_time(2)
    $Timer.start()
#    $UI/GUI/Choices.text = "awarded " + String(killed.stats.kill_xp) + " xp"
    
    if !killed.is_mob():
        var note = BoardNotification.instance()
        note.initialize(killed.player, null, killed.actor_name + " is dead!")
        notifications.append(note)
    else:
        if killed.defeated_trigger:
            get_parent().queue_cutscene(killed.get_cutscene_trigger())

func on_give_up(retiree):
    set_process_input(false)
    is_battle_over = true
#    $UI/GUI/Choices.text = retiree.player_name + " has given up!"
    print(retiree.player_name + " has given up!")
    $UI/CombatInterface.queue_free()
    $Timer.set_wait_time(2)
    $Timer.start()
    var note = Notification.instance()
    note.initialize(retiree, null, retiree.player_name + " is in timeout!")
    notifications.append(note) 

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
    fighter1.sync_stats()
    fighter2.sync_stats()
    if !is_battle_over:
        $Timer.stop()
        fighter1.player.battle = self
        fighter2.player.battle = self
    else:
        fighter2.flip_sprite()
        $"1".remove_child(fighter1)
        $"2".remove_child(fighter2)
        fighter1.player.battle = null
        fighter2.player.battle = null
        queue_free() 

func get_mob():
    if fighter2 is Mob:
        return fighter2

func _on_Timer_timeout():
    dealloc()
    print(get_signal_connection_list("completed"))
    emit_signal("completed", notifications)
    

func play_notification(note):
    $UI/NoteContainer.show()
    $UI/NoteContainer.add_child(note)
    note.show()
    $Timer.stop()
    yield(note, "tree_exited")
    $Timer.start()
    
func _on_CombatArena_tree_entered():
    set_process_input(false)
    if round_num > 0:
        $UI/CombatInterface.decide_turns()
