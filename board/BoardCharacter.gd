extends Node2D

class_name PlayerPawn

signal turn_finished
signal last_move_taken
signal camera_centered

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
var moves_left = 0
var spaces_moved = []
var board
var dice_roll_popup
var last_space
export (int) var turn_penalty = 0
var can_enter_scene = true
var ui_up = false
onready var my_turn = false
export (Vector2) var last_heal_space 
var _direction = Vector2()
var direction_names = { Vector2(-1,0) : "left", Vector2(1,0) : "right", Vector2(0,-1) : "up", Vector2(0,1) : "down" }
onready var Notification = preload("res://interface/UI/notification.tscn")
onready var ray = $Feeler
onready var timer = $MoveTimer

func initialize(game_board, _player, start):
    last_heal_space = start
    confirm_move_popup = game_board.get_node("UI/GUI/MoveConfirmPopup")
    player = _player
    dice_roll_popup = game_board.get_node("UI/GUI/DiceRollPopup")
    player_name = player.player_name
    board = game_board.get_node("GameBoard")
    game = get_node("/root/Game")

    refresh_after_load()
    last_space = start
    
func refresh_after_load():
    timer.connect("timeout", self, "check_moves")
    if confirm_move_popup:
        confirm_move_popup.connect("completed", self, "confirm_move", [], CONNECT_DEFERRED)
    $Feeler.add_exception($TileArea)
    spaces_moved = []
    set_process(false)
    set_process_input(false)

func set_position(new_pos):
    position = new_pos
    
func _input(event):
    if not my_turn:
        return
        
    if event is InputEventKey and event.scancode == KEY_X:
        GameSerializer.save_game(null)
    
    if ControlsHandler.is_current_player_action(event):
        _direction = get_input_direction(event)
        
func _process(_delta):
    if _direction != Vector2():
        $Pivot/AnimatedSprite.play(direction_names[_direction])
        var next_space = board.request_move(self, _direction)
        if next_space :
            move_to(board.map_to_world(next_space) + board.cell_size / 2)
        _direction = Vector2()
    
func move_to(target_position):
    set_process(false)
    # Move the node to the target cell instantly,
    # and animate the sprite moving from the start to the target cell
    
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

func check_moves():
    if moves_left <= 0:
        timer.stop()
        set_process(false)
        set_process_input(false)
        if !spaces_moved.empty():
            emit_signal("last_move_taken")
            # this is fucked, in terms of OOD, but I don't want to deal
            # with it right now
            var _yes = yield(confirm_move_popup, "completed")
        else: 
            print("check moves turn finished")
            end_turn()
    else:
        set_process(true)
    
func get_input_direction(event):
    print("player pawn " + String(player_id) + " is taking input")
    return Vector2(
        int(event.is_action_pressed("ui_right" + String(player_id))) - int(event.is_action_pressed("ui_left" + String(player_id))),
        int(event.is_action_pressed("ui_down" + String(player_id))) - int(event.is_action_pressed("ui_up" + String(player_id)))
    )
        
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
            print("confirm move turn finished")
            last_space = curr_space
            end_turn()
        else:
            move_to(spaces_moved.back())
            curr_space = position
            set_process_input(true)
            set_process(true)
            
        confirm_move_popup.hide()
    
func center_camera(last_camera_position  = camera.position):
    ("centering camera")
    var pos = $Pivot.to_local(last_camera_position)
    camera.position = pos
    camera._set_current(true)
    $Tween.interpolate_property($Pivot/Camera2D, "position", camera.position, Vector2(), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween, "tween_completed")
    emit_signal("camera_centered")

func start_turn():
    print(player_name + " board character turn")
    can_enter_scene = true
    
    if player.in_battle:
        print("in battle turn")
        end_turn()
        return
    if has_penalties():
        can_enter_scene = false
        print("dead turn")
        end_turn()
        return
    my_turn = true
    spaces_moved = []
    
    # todo don't use yield here, might fuck shit up
    moves_left = yield(dice_roll_popup, "completed")
#    moves_left = 1
    set_process_input(true)
    set_process(true)
    check_moves()
    curr_space = position
    last_space = curr_space
    spaces_moved = Array()

func on_killed(_p, _reward):
    turn_penalty = 3
    position = last_heal_space

func has_penalties():
    if turn_penalty == 0:
            return false
    else:
        turn_penalty = max(0, turn_penalty - 1)
        if turn_penalty == 0:
            on_revive()
            can_enter_scene = false
        var note = Notification.instance()
        note.initialize(self, null, player_name + " is in timeout!")
        game.add_note_to_q(note)
        return true

func get_camera_position():
    return camera.to_global(camera.position)
    
func on_revive():
    player.reset_stats()

func get_collisions():
    var combatants = []
    var collision_shapes = []
    print("ray colliding " + String(ray.is_colliding()))
    ray.force_raycast_update() #update the ray's collision query.
    if ray.is_colliding():
        while ray.is_colliding():
            var obj = ray.get_collider() #get the next object that is colliding.
            collision_shapes.append(obj) #add it to the array.
            ray.add_exception(obj) #add to ray's exception. That way it could detect something being behind it.
            ray.force_raycast_update() #update the ray's collision query.
            
    for obj in collision_shapes:
        combatants.append(obj.get_parent())
        ray.remove_exception(obj)
    ray.clear_exceptions()
    $Feeler.add_exception($TileArea)
    if !combatants.empty():
        return combatants
    else:
        return null
        
func end_turn():
    my_turn = false
    moves_left
    emit_signal("turn_finished")
    

func get_actor():
    return player.get_combatant()
    
func get_combatant():
    return player.get_combatant()
