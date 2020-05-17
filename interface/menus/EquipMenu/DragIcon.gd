extends TextureRect

var drag_position = null
var item : Item

func _process(_delta):
    pass
    
func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            drag_position = get_global_mouse_position() - rect_global_position
        else:
            drag_position = null
#            drop_data(drag_position, "test")
            queue_free()
    if event is InputEventMouseMotion and drag_position:
        rect_global_position = get_global_mouse_position() - drag_position

func can_drop_data(position, data):
    pass

