extends Node

var _direction = Vector2()
var direction_names = { Vector2(-1,0) : "left", Vector2(1,0) : "right", Vector2(0,-1) : "up", Vector2(0,1) : "down" }
var player_id = 0
func _ready():
    pass

func  _input(event):
    if event is InputEventKey:
        #this change might have made pausemode on board redundant
        _direction = get_input_direction(event)

func _process(delta):
    if _direction != Vector2() and _direction != Vector2(0,0):
        $AnimatedSprite.play(direction_names[_direction])
    
func get_input_direction(event):
    return Vector2(
        int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left")),
        int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up"))
    )   
