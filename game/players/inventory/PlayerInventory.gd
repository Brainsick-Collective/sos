extends Inventory

class_name PlayerInventory

onready var player = get_parent()
enum equip_type {WEAPON, OFFHAND, OFFENSIVE_MAGIC, DEFENSIVE_MAGIC}

func _ready():
    pass

func add(item, amount = 1):
    if item is CashItem:
        get_parent().cash += item.price
    else:
        .add(item, amount)


func get_equipment():
    var equipment = []
    for item in get_children():
        if item is Equipment:
            equipment.append(item)
    return equipment
     
func get_equipped_items():
    var ret = []
    for item in get_children():
        if item is Equipment and item.equipped:
            ret.append(item)
    return ret

func equip_item(item):
    assert(get_items().has(item))
    item.usable = false
    item.equipped = true
    player.equip_item(item)
