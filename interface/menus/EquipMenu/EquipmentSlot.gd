extends Panel

class_name EquipmentSlot

enum type {WEAPON, OFFHAND, OFFENSIVE_MAGIC, DEFENSIVE_MAGIC}

var active_item

export(type) var equipment_type

func set_item(item):
    assert(item.type == equipment_type)
    $TextureRect.texture = item.icon
    hint_tooltip = item.description
