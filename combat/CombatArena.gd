extends Node2D

var game_variables
var fighter1
var fighter2
var choice1
var choice2
const choices =[
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
	#TODO: set stats from stat resource

	$UI/CombatInterface.initialize(fighter1, fighter2)
	
func _process(delta):
	if choice1 and choice2:
		$Choices.text += "\n" + choice1 + "\n" + choice2
		set_process(false)
func _input(event):
	for key in choices:
		if !choice1 and event.is_action_pressed(key + String(fighter1.get_id())):
			choice1 = key
		elif !choice2 and event.is_action_pressed(key + String(fighter2.get_id())):
			choice2 = key
#	if event.is_action_pressed(