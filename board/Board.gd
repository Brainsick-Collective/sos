extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var START
onready var Characters = $GameBoard/Characters
onready var BoardCharacter = preload("res://board/BoardCharacter.tscn")
onready var Board = $GameBoard
onready var moves_label = $UI/GUI/Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $UI/GUI/NinePatchRect/PlayerName
var controls_handler
var Game
var num_players = 3
var current_player
var turn_ind

func _ready():
	var dummy = BoardCharacter.instance()
	current_player = dummy
	
func initialize(characters, game):
	_ready()
	Game = game
	controls_handler = game.get_node("ControlsHandler")
	START = $GameBoard/Start.get_position()
	for character in characters:
		character.set_position(START)
		Characters.add_child(character)
		character.connect("last_move", self, "show_confirm_popup")
	num_players = Characters.get_child_count()
	turn_ind = Characters.get_child_count() - 1
	Board.initialize()
	
func start_game():
	play_turn(Characters.get_child(0), START)

func _process(delta):
	moves_label.text =String( current_player.get_moves())
	
func play_turn(board_character, last_camera_position):
	current_player = board_character
	print("player" + String(current_player.player_id))
	board_character.start_turn(last_camera_position)
	set_process(true)
	set_process_input(true)
	name_label.text =String(board_character.get_name())
	moves_label.text = String(board_character.get_moves())
	yield(current_player, "turn_finished")
	var camera_pos = current_player.get_camera_position()
	var encounter = get_encounter(camera_pos)
	#if($GameBoard/Spaces.get_cellv($GameBoard/Spaces.world_to_map(camera_pos)) != -1):
	if encounter != null:
		print("encounter found")
		set_process(false)
		set_process_input(false)
		Game.enter_encounter(current_player.player_id, encounter)
	else:
		next_turn()
func next_turn():
	var last_camera_position = current_player.get_camera_position()
	var new_ind = (current_player.get_index() + 1) % num_players
	controls_handler.clear_controls()
	controls_handler.set_controls(new_ind)
	play_turn(Characters.get_child(new_ind), last_camera_position)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func show_confirm_popup():
	$UI/MoveConfirmPopup.show()

func get_encounter(camera_pos):
	#TODO: change to handle real encounters
	for character in Characters.get_children():
		print("position of player " + String(character.get_index()) + " " + String(character.position))
		if character.position == camera_pos and character != current_player:
			print("encounter found against " + String(character.player_id))
			return character.player_id