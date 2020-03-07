extends "res://interface/Menu.gd"

onready var Board = preload("res://board/Board.tscn")
onready var Character = preload("res://board/BoardCharacter.tscn")
onready var Player = preload("res://game/players/Player.tscn")
onready var StartingClasses = preload("res://game/StartingClasses.tscn")

onready var character_select_sprite = $Column/Row/Character
var Players
var current_class

var num_players
var classes
var game
var curr_player = 0
const min_size = 1
const max_size = 4
onready var characters = []

func _ready():
    classes = StartingClasses.instance()
    character_select_sprite.set_texture(classes.get_first().get_texture())
    num_players = 1
    curr_player = 1

    for i in range($Carts.get_child_count()):
        var cart = $Carts.get_child(i)
        cart.connect("entered", self, "_on_cartridge_hovered", [cart])
        cart.connect("exited", self, "_on_cartridge_left", [cart])
        cart.connect("pressed", self, "_on_cart_selected", [i])
        
func initialize(game_node, num):
    game = game_node
    num_players = num
    Players = game_node.get_node("Players")
    $PlayerLabel.text = "Player " + String(curr_player)
    current_class = classes.get_combatant()
    $Go.grab_focus()
    
func _on_cartridge_hovered(cart):
    if $Tween.is_active():
        return
    $Tween.interpolate_property(cart, "rect_position", cart.rect_position, cart.rect_position + Vector2(50,0), 0.1, Tween.TRANS_LINEAR)
    $Tween.start()
    print("hovered " + cart.name)
    yield($Tween, "tween_completed")
    
func _on_cartridge_left(cart):
    if $Tween.is_active():
        return
    print("left " + cart.name)
    $Tween.interpolate_property(cart, "rect_position", cart.rect_position, cart.rect_position - Vector2(50,0), 0.1, Tween.TRANS_LINEAR)
    $Tween.start()
    yield($Tween, "tween_completed")
    
func _on_cart_selected(index):
    current_class = classes.get_class_by_index(index)
    character_select_sprite.texture = current_class.get_sprite()
    
func get_player(character):
    for player in Players.get_children():
        if player.board_character == character:
            return player

func _process(_delta):
    $VBoxContainer/DescriptionPanel/Label.text = current_class.description
    $VBoxContainer/PanelContainer/Label.text = current_class.name
    


func _on_Go_pressed():    
    var player = Player.instance()
    player.player_name = $PlayerLabel.text
    var combatant = classes.get_combatant()
    var board_character = classes.get_pawn()
    characters.append(board_character)
    player.initialize(curr_player, board_character, combatant)
    combatant.initialize(player) 
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
        $PlayerLabel.text = "Player " + String(curr_player)


func _on_CosmeticSpinner_pressed():
    $CosmeticSpinner.set_rotation($CosmeticSpinner.get_rotation() + 1)
    pass # Replace with function body.
