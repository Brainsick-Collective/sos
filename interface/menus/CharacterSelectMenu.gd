extends "res://interface/Menu.gd"

onready var Board = preload("res://board/BoardManager.tscn")
onready var Character = preload("res://board/pawns/PlayerPawn.tscn")
onready var player_scene = preload("res://game/players/Player.tscn")
onready var StartingClasses = preload("res://game/StartingClasses.tscn")
onready var ControllerPicker = preload("res://interface/UI/PlayerControllerPicker.tscn")

onready var character_select_sprite = $SelectScreen/Column/Row/Character
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
    $SelectScreen/PlayerLabel.text = "Player " + String(curr_player)
    current_class = classes.get_combatant().instance()
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
    current_class = classes.get_class_by_index(index).instance()
    character_select_sprite.texture = current_class.get_sprite()
    
func get_player(character):
    for player in Players.get_children():
        if player.board_character == character:
            return player

func _process(_delta):
    $SelectScreen/VBoxContainer/DescriptionPanel/Label.text = current_class.description
    $SelectScreen/VBoxContainer/PanelContainer/Label.text = current_class.name
    if $ControllerChoices.visible:
        $Go.disabled = !check_valid_controllers()
    

func check_valid_controllers():
    var controller_choices = []
    var valid_choices = true
    
    for picker in $ControllerChoices.get_children():
        if picker.choice == -1 or controller_choices.has(picker.choice):
            valid_choices = false
        else:
            controller_choices.append(picker.choice)
    
    return valid_choices

func _on_Go_pressed():  
    if $SelectScreen.visible:
        var player = player_scene.instance()
        player.player_name = $SelectScreen/PlayerLabel.text
        var combatant = classes.get_combatant()
        var board_character = classes.get_pawn()
        characters.append(board_character)
        
        Players.add_child(player, true)
        player.initialize(curr_player, board_character, combatant)

    if curr_player == num_players:
        if !$SelectScreen.visible:
           start_game() 
        else:
            transition_to_controller_choice()
            $Go.disabled = true
    else:
        curr_player+=1
        $SelectScreen/PlayerLabel.text = "Player " + String(curr_player)

func transition_to_controller_choice():
    # TODO: animate
    $SelectScreen.hide()
    $Carts.hide()
    $ControllerChoices.show()
    for ind in Players.get_child_count():
        var picker = ControllerPicker.instance()
        picker.set_label(Players.get_child(ind).player_name)
        $ControllerChoices.add_child(picker)
        
func start_game():
    for player in Players.get_children():
        player.control_scheme_keyword = $ControllerChoices.get_child(player.id).get_choice()
    var board = Board.instance()
    game.add_child(board)
    board.initialize(characters, game)

    for character in characters:
        character.initialize(board, get_player(character), board.START)

    game.initialize_game(board)
    board.start_game()
    queue_free()

func _on_CosmeticSpinner_pressed():
    $CosmeticSpinner.set_rotation($CosmeticSpinner.get_rotation() + 1)
    pass # Replace with function body.
