extends Node2D

signal turn_finished(last_position)
signal last_move

export (Texture) var sprite
export (Resource) var stats
export (NodePath) var curr_space = null
export (String) var player_name
export (String) var player_id
export (Dictionary) var controls
const TIME_PER_SPACE = .1
onready var camera = $Pivot/Camera2D
var confirm_move_popup
var target_space
export var moves_left = 0
signal next_turn
var spaces_moved
var board
var dice_roll_popup
var timer
var ui_up = false
onready var my_turn = false

var _direction = Vector2()


func initialize(game_board):
	_ready()
	confirm_move_popup = game_board.get_node("UI/MoveConfirmPopup")
	
	dice_roll_popup = game_board.get_node("UI/DiceRollPopup")
	player_name = get_instance_id()
	#$moves.set_anchor(position - Vector2(32,96))
	#$moves.set_text(str(moves_left))
	board = game_board.get_node("GameBoard")
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
	#$moves.text=str(moves_left)
	_direction = get_input_direction()
	if _direction != Vector2():
		var next_space = board.request_move(self, _direction)
		if next_space :
			move_to(next_space)
		_direction = Vector2()
	#$Tween.start()
	
func move_to(target_position):
	set_process(false)
	target_position = board.map_to_world(board.world_to_map(target_position))
	target_position = target_position + board.cell_size / 2
	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
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


func check_moves():
	if moves_left <= 0:
		timer.stop()
		set_process(false)
		set_process_input(false)
		if !spaces_moved.empty():
			emit_signal("last_move")
			yield(confirm_move_popup, "completed")
		else:
			emit_signal("turn_finished", camera.to_global(camera.position))
			confirm_move_popup.disconnect("completed", self, "confirm_move")
	else:
		set_process(true)
	
func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
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
			emit_signal("turn_finished", camera.to_global(camera.position))
			confirm_move_popup.disconnect("completed", self, "confirm_move")
		else:
			move_to(spaces_moved.back())
			curr_space = position
		confirm_move_popup.hide()
	
func start_turn(last_camera_position):
	my_turn = true
	confirm_move_popup.connect("completed", self, "confirm_move")
	var pos = $Pivot.to_local(last_camera_position)
	
	spaces_moved = []
	camera.position = pos
	camera._set_current(true)
	$Tween.interpolate_property($Pivot/Camera2D, "position", camera.position, Vector2(), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	dice_roll_popup.initialize()
	moves_left = yield(dice_roll_popup, "completed")
	set_process_input(true)
	set_process(true)
	check_moves()
	curr_space = position
	spaces_moved = Array()
	