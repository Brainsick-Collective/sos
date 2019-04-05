extends Node2D

var game_variables
var controls_1
var controls_2
var fighter1
var fighter2
var has_chosen1
var has_chosen2
const controls =[
	"ui_accept",
	"ui_cancel",
	"ui_down",
	"ui_left",
	"ui_right",
	"ui_up"
]

func _ready():
	pass
	
func initialize(fighter1, fighter2):
	_ready()
	game_variables = get_node("/root/GameVariables")
	self.fighter1 = fighter1
	self.fighter2 = fighter2
	var sprite = Sprite.new()
	sprite.texture = fighter1.get_board_character().get_node("Pivot/Sprite").texture
	sprite.set_flip_h(true)
	$"1".add_child(sprite)
	var sprite2 = Sprite.new()
	sprite2.texture = fighter2.get_board_character().get_node("Pivot/Sprite").texture
	$"2".add_child(sprite2)
	$UI/CombatInterface1.initialize(game_variables.get_controls(fighter1.get_id()))
	$UI/CombatInterface2.initialize(game_variables.get_controls(fighter2.get_id()))
	
func _input(event):
	for key in controls:
		if event.is_action_pressed(key + String(fighter1.get_id())):
			print(key + "fighter 1")
#	if event.is_action_pressed(