extends Inventory

class_name PlayerInventory

func _ready():
    pass

#func _instance_item_from_db(reference):
#    var item = ItemDatabase.get_item(reference)
#    add_child(item)
#    item.add_to_group("save")
#    item.add_to_group("unique_to_save_file")
#    item.connect("depleted", self, "_on_Item_depleted", [item])
#    emit_signal("item_added", item)
#    return item
