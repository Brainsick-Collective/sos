extends Camera2D

enum {
    MODE_PLAYER,
    MODE_FOLLOW,
    MODE_ZOOM
}

const SNAP_DISTANCE = 0.05
const TARGET_VECTOR = Vector3(0,0,-1) # Targeting vector/angle, relative to target node. Multiplied by "distance".
const MIN_DISTANCE = 0.5
const MAX_DISTANCE = 2.5
const UP = Vector3(0,1,0)

export var speed = 2.0

var anchor   # To bring the camera back once it needs to. (Transform)
var target   # Node to follow or zoom on. (Node)
var distance # Distance when zooming in or out. (float)
var mode     # Currently active mode. (int)

func initialize(player):
	_ready()
	mode = MODE_PLAYER
	target = player
	position = player.position
	set_process(true)
	
func follow(target_node):
    if !is_processing():
        anchor = transform
        set_process(true)
    distance = 1.0
    target   = target_node
    mode     = MODE_FOLLOW

func zoom(target_node):
    if !is_processing():
        anchor = transform
        set_process(true)
    distance = 1.0
    target   = target_node
    mode     = MODE_ZOOM
    
func go_to_player():
    target = null
    mode   = MODE_PLAYER
    set_process(true)

func snap_to_player():
    transform = anchor
    set_process(false)

func _ready():
    set_process(false)
    mode = MODE_PLAYER
    anchor = transform
    distance = 1.0

func _process(delta): match mode:
    MODE_PLAYER:
        var newTransform = transform.interpolate_with(anchor, delta * speed)
        if newTransform.origin.distance_to(anchor.origin) < SNAP_DISTANCE:
            transform = anchor
            set_process(false)
        else:
            transform = newTransform
    MODE_FOLLOW:
        distance = clamp(distance + delta / 8, 1.0, MAX_DISTANCE)
        var targetTransform = target.global_transform
        targetTransform.origin += targetTransform.basis.xform(TARGET_VECTOR * distance)
        global_transform = global_transform.interpolate_with(targetTransform, delta * speed)
        look_at(target, UP)
    MODE_ZOOM:
        distance = clamp(distance - delta / 4, MIN_DISTANCE, 1.0)
        var targetTransform = target.global_transform
        targetTransform.origin += targetTransform.basis.xform(TARGET_VECTOR * distance)
        global_transform = global_transform.interpolate_with(targetTransform, delta * speed)
        look_at(target, UP)