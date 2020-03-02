extends Button

var item : Node

func set_item(_item):
    item  = _item
    text = item.display_name
#    icon = item.icon
    
func get_item():
    return item
