extends TextureRect

var drag_position = null
var item : Item
onready var ray = $ray

func _process(_delta):
    if ray.is_colliding():
        print("colliding")
    pass

func _ready():
    texture = item.icon
func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            drag_position = get_global_mouse_position() - rect_global_position
        else:
            drag_position = null
            if ray.is_colliding():
                var shape = ray.get_collider()
                shape.get_parent().take_item(item)
            queue_free()
    if event is InputEventMouseMotion and drag_position:
        rect_global_position = get_global_mouse_position() - drag_position

func can_drop_data(position, data):
    pass

