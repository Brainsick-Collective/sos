extends Button

class_name EquipmentSlot

enum type {WEAPON, OFFHAND, OFFENSIVE_MAGIC, DEFENSIVE_MAGIC}

var active_item

export(type) var equipment_type
func set_item(item):
    assert(item.type == equipment_type)
    $TextureRect.texture = item.icon
    hint_tooltip = item.description

func can_drop_data(_pos, data):
    if data.type == equipment_type:
        grab_focus()
        focus_mode = FOCUS_ALL
    return data is Item and data.type == equipment_type
    
func drop_data(position, data):
#    icon = data.icon
    set_item(data)
    focus_mode = FOCUS_NONE

func _on_Slot_mouse_entered():
    pass # Replace with function body.

func _on_Slot_mouse_exited():
    focus_mode = FOCUS_NONE
    pass # Replace with function body.
