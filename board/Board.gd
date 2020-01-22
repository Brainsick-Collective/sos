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
onready var Notification = preload("res://interface/UI/notification.tscn")
signal turn_finished(player)
var controls_handler
var game
var num_players = 3
var current_player
var turn_ind
func _ready():
    var dummy = BoardCharacter.instance()
    current_player = dummy
    
func initialize(characters, game):
    _ready()
    self.game = game
    game.board = self
    controls_handler = game.get_node("ControlsHandler")
    START = $GameBoard/Start.get_position()
    for character in characters:
        character.set_position(START)
        Characters.add_child(character)
        character.connect("last_move_taken", self, "show_confirm_popup")
    num_players = Characters.get_child_count()
    turn_ind = Characters.get_child_count() - 1
    Board.initialize()
    
func start_game():
    var note = Notification.instance()
    note.just_text("First Turn!")
    game.add_note_to_q(note)
    play_turn(Characters.get_child(0), START)

# warning-ignore:unused_argument
func _process(delta):
    moves_label.text = String( current_player.get_moves())
    
func play_turn(board_character, last_camera_position):
    current_player = board_character
    print("player" + String(current_player.player_id))
    print("penalty " + String(board_character.death_penalty))
    moves_label.text = String(board_character.get_moves())
    name_label.text =String(board_character.get_name())
    set_process(true)
    set_process_input(true)
    board_character.start_turn(last_camera_position)
    yield(board_character, "turn_finished")
    emit_signal("turn_finished", current_player)


func next_turn():
    var last_camera_position = current_player.get_camera_position()
    print("next turn starting, camera was last at: " + String(last_camera_position))
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
    if current_player.death_penalty > 0:
        return
    
    for character in Characters.get_children():
        print("position of player " + String(character.get_index()) + " " + String(character.position))
        print(String(character.player.stats.health))
        if character.position == camera_pos and character.player.stats.health != 0 and character != current_player:
            print("encounter found against " + String(character.player_id))
            return character.player_id
    


