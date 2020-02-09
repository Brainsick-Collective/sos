extends Node2D


onready var START
onready var Characters = $GameBoard/Characters
onready var BoardCharacter = preload("res://board/BoardCharacter.tscn")
onready var Board = $GameBoard
onready var moves_label = $UI/GUI/Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $UI/GUI/NinePatchRect/PlayerName
onready var GUI = $UI/GUI
onready var Notification = preload("res://interface/UI/notification.tscn")
signal turn_finished(player)
var game
var num_players
var current_player
var turn_ind
func _ready():
    var dummy = BoardCharacter.instance()
    current_player = dummy
    
func initialize(characters, game):
    _ready()
    self.game = game
    game.board = self
    num_players = characters.size()
    START = $GameBoard/Start.get_position()
    for character in characters:
        character.set_position(START)
        Characters.add_child(character)
        character.connect("last_move_taken", self, "show_confirm_popup")
    num_players = Characters.get_child_count()
    turn_ind = Characters.get_child_count() - 1
    Board.initialize()
    GUI.initialize(self)
    
func start_game():
    GUI.hide()
    var cutscene = game.load_cutscene("res://dialogue/intro_cutscene.json")
    yield(cutscene, "tree_exited")
    GUI.show()
    play_turn(Characters.get_child(0), START)

# warning-ignore:unused_argument
func _process(delta):
    moves_label.text = String( current_player.get_moves())
    
func play_turn(board_character, last_camera_position):
    current_player = board_character
    GUI.change_player(board_character.player)
    set_process(true)
    set_process_input(true)
    board_character.start_turn(last_camera_position)
    yield(board_character, "turn_finished")
    emit_signal("turn_finished", current_player)


func next_turn():
    var last_camera_position = current_player.get_camera_position()
    var new_ind = (current_player.get_index() + 1) % num_players
    ControlsHandler.clear_controls()
    ControlsHandler.set_controls(new_ind)
    ControlsHandler.current_player = new_ind
    play_turn(Characters.get_child(new_ind), last_camera_position)

func enter_shop(player_pawn, location):
    var shop = ShopFactory.get_shop(player_pawn, location)
    get_tree().paused = true
    yield(shop, "tree_exited")
    get_tree().paused = false
    
    
    
func show_confirm_popup():
    $UI/GUI/MoveConfirmPopup.show()

