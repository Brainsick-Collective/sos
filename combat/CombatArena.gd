extends Node2D

class_name CombatArena

var game_variables
var fighter1
var fighter2
var choice1
var choice2
var fighter1chose
var fighter2chose
var isfighter1First
var round_num
var is_over = false
var notifications = []
enum move_types { empty = -1, normal, special, magic, effect }
onready var Notification = preload("res://interface/UI/notification.tscn")

signal combat_finished
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
    game_variables = get_node("/root/GameVariables")
    fighter1.connect("killed", self, "on_won_battle")
    fighter2.connect("killed", self, "on_won_battle")
    game_variables.set_default_moves(fighter1)
    game_variables.set_default_moves(fighter2)
    fighter1chose = false
    fighter2chose = false
    round_num = 0
    #temp code, change to combatant
    #var sprite = Sprite.new()
    #sprite.texture = fighter1.get_board_character().get_node("Pivot/Sprite").texture
    #sprite.set_flip_h(true)
    $"1".add_child(fighter1)
    #var sprite2 = Sprite.new()
    #sprite2.texture = fighter2.get_board_character().get_node("Pivot/Sprite").texture
    $"2".add_child(fighter2)
    fighter2.flip_sprite()
    #----
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress.max_value = fighter1.stats.max_health
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress.max_value = fighter2.stats.max_health
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/Name.text = fighter1.player.player_name
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/Name.text = fighter2.player.player_name
    process_gui_values()
    #TODO: set stats from stat resource
    set_process_input(false)
    $UI/CombatInterface.initialize(fighter1, fighter2)
    $UI/CombatInterface/TurnOrderPopup.connect("chosen", self, "on_choice")
    $UI/GUI/C1Label.text = fighter1.get_stats_string()
    $UI/GUI/C2Label.text = fighter2.get_stats_string()
    print(fighter1.is_mob())
    print(fighter2.is_mob())
    
    
func set_fighters(fighter1, fighter2):
    self.fighter1 = fighter1
    self.fighter2 = fighter2
func _process(delta):
    process_gui_values()
    check_ready()
    
    
func check_ready():
    if fighter2.is_mob() and fighter1chose:
        choice2 = move_types.normal
        fighter2chose = true
        print("mob chose")
    if fighter1chose and fighter2chose and !is_over:
        set_process_input(false)
        set_process(false)
        print("players have chosen their moves")
        $UI/GUI/Choices.text = "Choices:\n" + fighter1.get_move(choice1, true).move.move_name + "\n" + fighter2.get_move(choice2,false).move_name
        if isfighter1First:
            do_phase(fighter1, fighter2, fighter1.get_move(choice1, true), fighter2.get_move(choice2, false))
        else:
            do_phase(fighter2, fighter1, fighter2.get_move(choice2, true), fighter1.get_move(choice1, false))
    

func do_phase(attacker, defender, attacker_move, defender_move):
    var hit = attacker_move.execute(defender,defender_move)
    round_num += 1
        #add that defender_move  animation still plays
    print("doing move calculations...")
    print(attacker_move.move.move_name)
    print(defender_move.move_name)
    fighter1chose = false
    fighter2chose = false
    if defender_move.type == move_types.effect:
        on_give_up(defender.player)
        return
    if hit:
        hit.execute()
        print("executing hit")
    process_gui_values()
    if !is_over:
        if round_num % 2 == 1:
            isfighter1First = !isfighter1First
            $UI/CombatInterface.do_combat_phase(isfighter1First)
        else:
            $Timer.set_wait_time(2)
            $Timer.start()
            yield($Timer, "timeout")
            dealloc(false)
            emit_signal("completed")
    set_process_input(true)
    set_process(true)

func _input(event):
    if(fighter1.get_id() == -1):
        print("WHYYYYY?" + fighter1.player.player_name)
    for key in choices:
        if !fighter1chose and event.is_action_pressed(key + String(fighter1.get_id())):
            choice1 = choice_map[key]
            fighter1chose = true
        elif !fighter2chose and !fighter2.is_mob() and event.is_action_pressed(key + String(fighter2.get_id())):
            choice2 = choice_map[key]
            fighter2chose = true
#	if event.is_action_pressed(

func process_gui_values():
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress.value = fighter1.stats.health
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress.value = fighter2.stats.health
    $UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress/Label.text = String(fighter1.stats.health)
    $UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress/Label.text = String(fighter2.stats.health)
    $UI/GUI/C1Label.text = fighter1.get_stats_string()
    $UI/GUI/C2Label.text = fighter2.get_stats_string()
    
func on_choice(choice):
    isfighter1First = choice
    set_process_input(true)
    
func on_won_battle(killed):
    set_process_input(false)
    is_over = true
    $UI/GUI/Choices.text = killed.player_name + " has been killed!"
    var kill_desc = killed.player_name + " has been killed!"
    print(kill_desc)
    process_gui_values()
    $Timer.set_wait_time(2)
    $Timer.start()
    yield($Timer, "timeout")
    dealloc(true)
    var note = Notification.instance()
    note.init(killed, null, killed.player_name + " is dead!")
    notifications.append(note)
    emit_signal("completed", notifications)
    
func on_give_up(retiree):
    set_process_input(false)
    is_over = true
    $UI/GUI/Choices.text = retiree.player_name + " has given up!"
    print(retiree.player_name + " has given up!")
    process_gui_values()
    $UI/CombatInterface.queue_free()
    $Timer.set_wait_time(2)
    $Timer.start()
    yield($Timer, "timeout")
    dealloc(true)
    var note = Notification.instance()
    note.init(retiree, null, retiree.player_name + " is in timeout!")
    notifications.append(note)
    emit_signal("completed", notifications)

func dealloc(is_finished):
    fighter1.player.in_battle = !is_finished
    fighter2.player.in_battle = !is_finished
    if !is_finished:
        fighter1.player.battle = self
        fighter2.player.battle = self
    else:
        $"1".remove_child(fighter1)
        $"2".remove_child(fighter2)
        fighter1.player.battle = null
        fighter2.player.battle = null
        queue_free() 
