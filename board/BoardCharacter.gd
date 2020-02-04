extends Node2D

class_name BoardCharacter

signal turn_finished
signal last_move_taken

export (NodePath) var curr_space = null
export (String) var player_name
export (String) var player_id
var player
var game
export (Dictionary) var controls
const TIME_PER_SPACE = .1
onready var camera = $Pivot/Camera2D
var confirm_move_popup
var target_space
export var moves_left = 0
var spaces_moved
var board
var dice_roll_popup
var timer
export (int) var death_penalty = 0
var is_dead = false
var ui_up = false
onready var my_turn = false
export (Vector2) var last_heal_space 
var _direction = Vector2()
onready var Notification = preload("res://interface/UI/notification.tscn")


func initialize(game_board, player, start):
    _ready()
    last_heal_space = start
    confirm_move_popup = game_board.get_node("UI/MoveConfirmPopup")
    self.player = player
    dice_roll_popup = game_board.get_node("UI/DiceRollPopup")
    player_name = player.player_name
    #$moves.set_anchor(position - Vector2(32,96))
    #$moves.set_text(str(moves_left))
    board = game_board.get_node("GameBoard")
    game = get_node("/root/Game")
    timer = Timer.new()
    add_child(timer)
    timer.connect("timeout", self, "check_moves")
    # Called when the node is added to the scene for the first time.
    # Initialization here
    set_process(false)
    set_process_input(false)

func set_position(new_pos):
    position = new_pos

func set_sprite(new_sprite):
    $Pivot/Sprite.texture = new_sprite
    
func _process(delta):
    _direction = get_input_direction()
    if _direction != Vector2():
        var next_space = board.request_move(self, _direction)
        if next_space :
            move_to(next_space)
        _direction = Vector2()
    
func move_to(target_position):
    set_process(false)
    target_position = board.map_to_world(board.world_to_map(target_position))
    target_position = target_position + board.cell_size / 2
    # Move the node to the target cell instantly,
    # and animate the sprite moving from the start to the target cell
    
    #use this for sprite facing direction
    var move_direction = (target_position - position).normalized()
    var old_pos = position
    position = target_position
    $Pivot.position = to_local(old_pos)
    var num_spaces = board.get_num_spaces(old_pos, position)
    var spaces_delay = num_spaces * TIME_PER_SPACE
    $Tween.interpolate_property($Pivot, "position", $Pivot.position, Vector2(), spaces_delay, Tween.TRANS_LINEAR, Tween.EASE_IN)
    $Tween.start()
    timer.set_wait_time(spaces_delay)
    timer.set_one_shot(true)
    timer.start()
    if !spaces_moved.empty():
        if target_position == spaces_moved.back():
            moves_left+=1
            spaces_moved.pop_back()
            curr_space = target_position
            target_space = null
            return
    moves_left-=1
    spaces_moved.push_back(curr_space)
    curr_space = target_position
    target_position = null

func get_fighter():
    return player.combatant
func check_moves():
    if moves_left <= 0:
        timer.stop()
        set_process(false)
        set_process_input(false)
        if !spaces_moved.empty():
            emit_signal("last_move_taken")
            yield(confirm_move_popup, "completed")
        else:
            emit_signal("turn_finished")
            confirm_move_popup.disconnect("completed", self, "confirm_move")
    else:
        set_process(true)
    
func get_input_direction():
    return Vector2(
        int(Input.is_action_pressed("ui_right" + String(player_id))) - int(Input.is_action_pressed("ui_left" + String(player_id))),
        int(Input.is_action_pressed("ui_down" + String(player_id))) - int(Input.is_action_pressed("ui_up" + String(player_id)))
    )

func update_look_direction(direction):
#	$Pivot/Sprite.rotation = direction.angle()
    pass
        
func get_moves():
    return moves_left
func get_name(): 
    return player_name

func confirm_move(isYes):
    if my_turn:
        if isYes:
            set_process(false)
            set_process_input(false)
            timer.stop()
            my_turn = false
            emit_signal("turn_finished")
            confirm_move_popup.disconnect("completed", self, "confirm_move")
        else:
            move_to(spaces_moved.back())
            curr_space = position
        confirm_move_popup.hide()
    
func center_camera():
    ("centering camera")
    var pos = $Pivot.to_local(camera.position)
    camera.position = pos
    camera._set_current(true)
    $Tween.interpolate_property($Pivot/Camera2D, "position", camera.position, Vector2(), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween, "tween_completed")

func start_turn(last_camera_position):
    var pos = $Pivot.to_local(last_camera_position)
    camera.position = pos
    camera._set_current(true)
    $Tween.interpolate_property($Pivot/Camera2D, "position", camera.position, Vector2(), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween, "tween_completed")
    #TODO: use a state machine for player conditions, i.e. in battle, dead, penalty
    if player.in_battle:
        emit_signal("turn_finished")
        return
    check_penalties()
    if is_dead:
        emit_signal("turn_finished")
        return
    my_turn = true
    confirm_move_popup.connect("completed", self, "confirm_move")
    spaces_moved = []
    dice_roll_popup.initialize()
    moves_left = yield(dice_roll_popup, "completed")
#    moves_left = 1
    set_process_input(true)
    set_process(true)
    check_moves()
    curr_space = position
    spaces_moved = Array()

func get_camera_position():
    return camera.to_global(camera.position)
    
func on_killed(p):
    death_penalty = 3
    is_dead = true
    position = last_heal_space
    ("player health on death: " + String(p.stats.health))

func on_revive():
    is_dead = false
    player.reset_stats()
    
func check_penalties():
    if death_penalty == 0:
            on_revive()
            return
    else:
        death_penalty = max(0, death_penalty - 1)
        var note = Notification.instance()
        note.init(player, null, player.player_name + " is in timeout!")
        game.add_note_to_q(note) 
    return
