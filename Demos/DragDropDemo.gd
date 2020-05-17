extends Control

func _ready():
    $ItemButton.dragable = true
    $ItemButton.connect("button_dragged", self, "button_dragged")
    
func button_dragged(drag_icon):
    set_default_cursor_shape(CURSOR_DRAG)
    add_child(drag_icon)
    drag_icon.rect_position = get_global_mouse_position() - drag_icon.rect_pivot_offset
    drag_icon.drag_position = get_global_mouse_position() - drag_icon.rect_position 
