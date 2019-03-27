extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var START
onready var Characters = $GameBoard/Characters
onready var Board = $GameBoard
onready var BoardPath = $GameBoard/Path
onready var moves_label = $UI/GUI/Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $UI/GUI/NinePatchRect/PlayerName
var num_players = 3
var current_player

func initialize(characters):
	_ready()
	START = $GameBoard/Start.get_position()
	for character in characters:
		character.set_position(START)
		character.connect("next_turn",self,"next_turn")
		Characters.add_child(character)
		character.initialize(self)
	num_players = Characters.get_child_count()
	play_turn(Characters.get_child(0))
	Board.initialize()
	#$Characters.get_child(0).set_current_camera()

func _process(delta):
	name_label.text =String( current_player.get_name())
	
func play_turn(player):
	current_player = player
	player.start_turn()
	name_label.text =String( player.get_name())
	moves_label.text = String(player.get_moves())
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

