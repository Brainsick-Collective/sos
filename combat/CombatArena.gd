extends Node2D

var game_variables
var fighter1
var fighter2
var choice1
var choice2
var fighter1chose
var fighter2chose
var isfighter1First
var round_num
enum move_types { empty = -1, normal, special, magic, effect }

signal round_finished
signal combat_finished

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
	
func initialize(fighter1, fighter2):
	_ready()
	game_variables = get_node("/root/GameVariables")
	self.fighter1 = fighter1
	self.fighter2 = fighter2
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
	#----
	$UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress.max_value = fighter1.stats.max_health
	$UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress.max_value = fighter2.stats.max_health
	
	#TODO: set stats from stat resource
	set_process_input(false)
	$UI/CombatInterface.initialize(fighter1, fighter2)
	$UI/CombatInterface/TurnOrderPopup.connect("chosen", self, "on_choice")
	$UI/GUI/C1Label.text = fighter1.get_stats_string()
	
func _process(delta):
	if fighter1chose and fighter2chose:
		set_process_input(false)
		if isfighter1First:
			do_phase(fighter1, fighter2, fighter1.get_move(choice1, true), fighter2.get_move(choice2, false))
		else:
			do_phase(fighter2, fighter1, fighter2.get_move(choice2, true), fighter1.get_move(choice1, false))
		$UI/GUI/Choices.text = "Choices:\n" + fighter1.get_move(choice1, true).move.move_name + "\n" + fighter2.get_move(choice2,false).move_name
		set_process(false)
		if round_num % 2 == 1:
			isfighter1First = !isfighter1First
			$UI/CombatInterface.do_combat_phase(isfighter1First)
			set_process_input(true)
			set_process(true)
			fighter1chose = false
			fighter2chose = false
		else:
			dealloc(false)
			emit_signal("round_finished")
	$UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress.value = fighter1.stats.health
	$UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress.value = fighter2.stats.health
	$UI/GUI/ActorPanel1/Margins/VBoxContainer/TextureProgress/Label.text = String(fighter1.stats.health)
	$UI/GUI/ActorPanel2/Margins/VBoxContainer/TextureProgress/Label.text = String(fighter2.stats.health)
	
	
func do_phase(attacker, defender, attacker_move, defender_move):
	var hit = attacker_move.execute(defender,defender_move)
	round_num += 1
		#add that defender_move  animation still plays
	print(attacker_move.move.move_name)
	print(defender_move.move_name)
	if hit:
		hit.execute()

func _input(event):
	for key in choices:
		if !fighter1chose and event.is_action_pressed(key + String(fighter1.get_id())):
			choice1 = choice_map[key]
			fighter1chose = true
		elif !fighter2chose and event.is_action_pressed(key + String(fighter2.get_id())):
			choice2 = choice_map[key]
			fighter2chose = true
#	if event.is_action_pressed(

func on_choice(choice):
	isfighter1First = choice
	set_process_input(true)
	
func on_won_battle(victor):
	emit_signal("combat_finished")
	$UI/GUI/Choices.text = victor.player_name + "Has Won!"
	dealloc(true)

func dealloc(is_finished):
	$"1".remove_child(fighter1)
	$"2".remove_child(fighter2)
	if is_finished:
		fighter1.player.in_battle = false
		fighter2.player.in_battle = false
	else:
		fighter1.player.in_battle = true
		fighter2.player.in_battle = true
	queue_free()
	