extends "res://interface/Menu.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var Board = preload("res://board/Board.tscn")
onready var Character = preload("res://board/BoardCharacter.tscn")
onready var Player = preload("res://game/players/Player.tscn")
onready var left = $Column/Row/Left
onready var right = $Column/Row/Right
onready var character = $Column/Row/Character
onready var Sprites = preload("res://assets/pokemon.tscn")
onready var num_players_label = $Column0/Row/Container/Label
var Players

var num_players
var sprites
var game
var curr_player = 0
const min_size = 1
const max_size = 4
onready var characters = []
signal enter_board(board_node)


func _ready():
	sprites = Sprites.instance()
	character.set_texture(sprites.get_first().get_texture())
	num_players = 1
	curr_player = 1

func initialize(game_node):
	_ready()
	game = game_node
	Players = game_node.get_node("Players")
	

func _input(event):
	if event.is_action_pressed("ui_left"):
		if($Column.is_visible_in_tree()):
			character.set_texture(sprites.last_sprite())
		else:
			num_players= clamp(num_players-1,min_size, max_size)
	elif event.is_action_pressed("ui_right"):
		if($Column.is_visible_in_tree()):
			character.set_texture(sprites.next_sprite())
		else:
			num_players= clamp(num_players+1,min_size, max_size)
	if event.is_action_pressed("ui_accept"):
		$Column.show()
		$Column0.hide()


func _process(delta):
	num_players_label.text = String(num_players)
	$Column/PlayerLabel.text = "Player " + String(curr_player)

func _on_StartButton_pressed():
	var board_character = Character.instance()
	board_character.set_sprite(character.texture)
	characters.append(board_character)
	var player = Player.instance()
	player.initialize(curr_player, board_character)
	Players.add_child(player)
	if curr_player == num_players:
		var board = Board.instance()
		game.add_child(board)
		board.initialize(characters, game)
		game.set_controls()
		queue_free()
	else:
		curr_player+=1