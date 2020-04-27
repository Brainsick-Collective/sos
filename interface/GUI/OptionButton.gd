extends Button

var item : Node

func _ready():
    set_process_input(false)

func set_item(_item : Item):
    item  = _item
    text = item.display_name
    if item is CashItem:
        text = item.name
    icon = item.icon
#    icon = item.icon
    
func get_item():
    return item
