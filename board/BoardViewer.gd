extends KinematicBody2D

var direction : Vector2
var speed = 10
onready var camera = $Camera2D
var actors : Array
var collision_shapes = []
onready var ray = $feeler
var on_space = false

signal actor_found(actors)
signal actor_left()

func _ready():
    set_process_input(false)
    set_physics_process(false)
    pass


func _physics_process(_delta):
    direction = ControlsHandler.get_current_player_direction()
# warning-ignore:return_value_discarded
    move_and_collide(direction.normalized() * speed)
    
    if ray.is_colliding():
        collision_shapes = []
        if not on_space:
            on_space = true
            while ray.is_colliding():
                var obj = ray.get_collider() #get the next object that is colliding.
                collision_shapes.append(obj) #add it to the array.
                ray.add_exception(obj) #add to ray's exception. That way it could detect something being behind it.
                ray.force_raycast_update() #update the ray's collision query.
    
            var combatants = []
            for obj in collision_shapes:
                if obj is Combatant:
                    combatants.append(obj.get_parent().get_actor())
            emit_signal("actor_found", combatants)
            
            for obj in collision_shapes:
                ray.remove_exception(obj)
            collision_shapes = []
    elif on_space:
        emit_signal("actor_left")
        on_space = false

func _input(event):
    if event is InputEventKey and ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [get_parent().current_player.player]):
        get_parent().return_to_player(to_global(camera.position))
