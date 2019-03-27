extends Node2D

signal moved

export (Texture) var sprite
export (Resource) var stats
export (NodePath) var curr_space = null
export (String) var player_name
const TIME_PER_SPACE = .1
onready var camera = $Pivot/Camera2D
var target_space
var moving = false
export var moves_left = 0
signal next_turn
var spaces_moved
var board
var timer

var _direction = Vector2()


func initialize(game_board):
	_ready()
	player_name = randi() % 10
	#$moves.set_anchor(position - Vector2(32,96))
	#$moves.set_text(str(moves_left))
	board = game_board.get_node("GameBoard")
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
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
		if next_space:
			move_to(next_space)
		_direction = Vector2()
	#$Tween.start()
	
func move_to(target_position):
	emit_signal("moved", position, target_position)
	set_process(false)
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
	#yield(timer, "timeout")
	
	#yield(anim.play_walk(), "completed")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func on_timeout():
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
	
func start_turn():
	camera._set_current(true)
	spaces_moved = Array()
	moves_left = 3
	set_process(true)
	set_process_input(true)
	#$moves.show()

	