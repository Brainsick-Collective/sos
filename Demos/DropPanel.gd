extends Button

var mouse_in : bool = false

func can_drop_data(_pos, data):
    focus_mode = FOCUS_ALL
    grab_focus()
    return data is Item
    
func drop_data(position, data):
    icon = data.icon
    focus_mode = FOCUS_NONE

func _on_Slot_mouse_entered():
    pass # Replace with function body.

func _on_Slot_mouse_exited():
    focus_mode = FOCUS_NONE
    pass # Replace with function body.
