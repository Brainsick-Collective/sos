extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var START
onready var Characters = $GameBoard/Characters
onready var BoardCharacter = preload("res://board/BoardCharacter.tscn")
onready var Board = $GameBoard
onready var BoardPath = $GameBoard/Path
onready var moves_label = $UI/GUI/Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $UI/GUI/NinePatchRect/PlayerName
onready var DiceRoll = $UI/DiceRollPopup
var num_players = 3
var current_player
var turn_ind

func _ready():
	var dummy = BoardCharacter.instance()
	current_player = dummy
	
func initialize(characters):
	_ready()
	START = $GameBoard/Start.get_position()
	for character in characters:
		character.set_position(START)
		Characters.add_child(character)
		character.initialize(self)
		character.connect("turn_finished", self, "next_turn")
		character.connect("last_move", self, "show_confirm_popup")
	num_players = Characters.get_child_count()
	turn_ind = Characters.get_child_count() - 1
	print(num_players)
	
	play_turn(Characters.get_child(0), START)
	Board.initialize()
	#$Characters.get_child(0).set_current_camera()

func _process(delta):
	moves_label.text =String( current_player.get_moves())
	
func play_turn(player, last_camera_position):
	current_player = player
	player.start_turn(last_camera_position)
	name_label.text =String( player.get_name())
	moves_label.text = String(player.get_moves())

func next_turn(last_camera_position):
	var new_ind = (current_player.get_index() + 1) % num_players
	play_turn(Characters.get_child(new_ind), last_camera_position)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func show_confirm_popup():
	$UI/MoveConfirmPopup.show()
