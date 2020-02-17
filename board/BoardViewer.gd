extends KinematicBody2D

var direction : Vector2
var speed = 10
onready var camera = $Camera2D
var actors : Array
var currently_viewing = false
signal actor_found(actors)
signal actor_left()

func _ready():
    set_process_input(false)
    set_physics_process(false)
    pass


func _physics_process(delta):
    direction = ControlsHandler.get_current_player_direction()
    move_and_collide(direction.normalized() * speed)
    actors = get_node("../GameBoard").find_combatants_for_space(position)
    if actors and !currently_viewing:
        emit_signal("actor_found", actors)
        currently_viewing = true
    if actors.empty():
        currently_viewing = false
        emit_signal("actor_left")
func _input(event):
    if ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [get_parent().current_player.player]):
        get_parent().return_to_player(to_global(camera.position))
