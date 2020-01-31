extends "res://interface/Menu.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var Board = preload("res://board/Board.tscn")
onready var Character = preload("res://board/BoardCharacter.tscn")
onready var Player = preload("res://game/players/Player.tscn")
onready var StartingClasses = preload("res://game/StartingClasses.tscn")
onready var left = $Column/Row/Left
onready var right = $Column/Row/Right
onready var character_select_sprite = $Column/Row/Character
onready var num_players_label = $Column0/Row/Container/Label
var Players

var num_players
var classes
var game
var curr_player = 0
const min_size = 1
const max_size = 4
onready var characters = []
signal enter_board(board_node)


func _ready():
    classes = StartingClasses.instance()
    character_select_sprite.set_texture(classes.get_first().get_texture())
    num_players = 1
    curr_player = 1

func initialize(game_node):
    _ready()
    game = game_node
    Players = game_node.get_node("Players")
    

func _input(event):
    if event.is_action_pressed("ui_left"):
        if($Column.is_visible_in_tree()):
            character_select_sprite.set_texture(classes.last_sprite())
        else:
            num_players= clamp(num_players-1,min_size, max_size)
    elif event.is_action_pressed("ui_right"):
        if($Column.is_visible_in_tree()):
            character_select_sprite.set_texture(classes.next_sprite())
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
    var player = Player.instance()
    
    board_character.set_sprite(classes.get_board_piece())
    characters.append(board_character)
    var combatant = classes.get_combatant()
    player.initialize(curr_player, board_character, combatant)
    combatant.initialize(character_select_sprite, player)
    player.player_name = "Player " + String(curr_player)
    Players.add_child(player)
    if curr_player == num_players:
        var board = Board.instance()
        game.add_child(board)
        board.initialize(characters, game)
        for character in characters:
            character.initialize(board, get_player(character), board.START)
        game.initialize_game(board)
        board.start_game()
        queue_free()
    else:
        curr_player+=1
    
func get_player(character):
    for player in Players.get_children():
        if player.board_character == character:
            return player
