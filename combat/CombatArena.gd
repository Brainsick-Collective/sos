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
func _ready():
    pass
    
func initialize():
    _ready() 
    fighter1.connect("killed", self, "on_won_battle")
    fighter2.connect("killed", self, "on_won_battle")
    fighter1.stats.connect("leveled_up", self, "play_notification")
    fighter2.stats.connect("leveled_up", self, "play_notification")
    fighter1chose = false
    fighter2chose = false
    $"1".add_child(fighter1)
    $"2".add_child(fighter2)
    fighter2.flip_sprite()
    $MatchupInterface.initialize(fighter1, fighter2)
    $UI/CombatInterface.initialize(fighter1, fighter2)
    $UI/CombatInterface/TurnOrderPopup.connect("chosen", self, "on_choice")
    
    $UI/CombatInterface.decide_turns()
    stage_ui()
    set_process_input(false)    
    
func stage_ui():
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress.max_value = fighter1.stats.max_health
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/HBoxContainer/TextureProgress.max_value = fighter2.stats.max_health
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/Name.text = fighter1.player.player_name
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/Name.text = fighter2.player.player_name
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/HBoxContainer/LVL.text = "LVL " + String(fighter1.stats.level)
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/HBoxContainer/LVL.text = "LVL " + String(fighter2.stats.level)
    process_gui_values()
    
func set_fighters(fighter1, fighter2):
    self.fighter1 = fighter1
    self.fighter2 = fighter2
func _process(delta):
    process_gui_values()
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
    process_gui_values()
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

func process_gui_values():
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress.value = fighter1.stats.health
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/HBoxContainer/TextureProgress.value = fighter2.stats.health
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress/Label.text = String(fighter1.stats.health)
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/HBoxContainer/TextureProgress/Label.text = String(fighter2.stats.health)

func on_choice(choice):
    isfighter1First = choice
    var attacker
    if isfighter1First:
        attacker = fighter1
    else:
        attacker = fighter2
    $MatchupInterface.set_predictions(attacker)
    set_process_input(true)
    
func on_won_battle(killed):
    set_process_input(false)
    is_battle_over = true
#    $UI/GUI/Choices.text = killed.combatant_name + " has been killed!"
    var kill_desc = killed.combatant_name + " has been killed!"
    print(kill_desc)
    process_gui_values()
    $Timer.set_wait_time(2)
    $Timer.start()
    
#    $UI/GUI/Choices.text = "awarded " + String(killed.stats.kill_xp) + " xp"
    var winner = null
    if fighter1 == killed:
        winner = fighter2
    else:
        winner = fighter1
    winner.stats.set_xp(winner.stats.get_xp() + killed.stats.kill_xp)
    var note = Notification.instance()
    if !killed.is_mob():
        note.init(killed.player, null, killed.combatant_name + " is dead!")
        notifications.append(note)

func reverse_tween():
    var pos = null
    if tween_to_reverse.get_parent().get_parent() == get_node("1"):
        pos = $"1".position
    else:
        pos = $"2".position
    tween_to_reverse.interpolate
func on_give_up(retiree):
    set_process_input(false)
    is_battle_over = true
#    $UI/GUI/Choices.text = retiree.player_name + " has given up!"
    print(retiree.player_name + " has given up!")
    process_gui_values()
    $UI/CombatInterface.queue_free()
    $Timer.set_wait_time(2)
    $Timer.start()
    var note = Notification.instance()
    note.init(retiree, null, retiree.player_name + " is in timeout!")
    notifications.append(note) 


func dealloc():
    fighter1.player.in_battle = !is_battle_over
    fighter2.player.in_battle = !is_battle_over
    $Timer.stop()
    if !is_battle_over:
        fighter1.player.battle = self
        fighter2.player.battle = self
        
    else:
        fighter2.flip_sprite()
        $"1".remove_child(fighter1)
        $"2".remove_child(fighter2)
        fighter1.player.battle = null
        fighter2.player.battle = null
        queue_free() 


func _on_Timer_timeout():
    emit_signal("completed", notifications)
    dealloc()

func play_notification(note):
    $UI/NoteContainer.show()
    $UI/NoteContainer.add_child(note)
    note.show()
    $Timer.stop()
    yield(note, "tree_exited")
    $Timer.start()
    
func _on_CombatArena_tree_entered():
    set_process_input(true)
    if round_num > 0:
        $UI/CombatInterface.decide_turns()
