extends Sprite

var item

func _input(event):
    if event.is_action_released("mouse_left"):
        drop_item(item)
        
        
func drop_item(item):
    var ray = $Ray
    if ray.is_colliding():
        var shape = ray.get_collider()
        shape.get_parent().take_item(item)
