extends Control


## TODO make a class for inventory and extend it for player and shop

export(PackedScene) var ItemButton
var inventory
signal item_bought(item)
var player

onready var _item_grid = $Row/Column/ItemList/Margin/Grid
onready var _description_label = $Row/Column/Description/Margin/Label

func set_inventory(inv):
    inventory = inv
    
func initialize(p):
    player = p
    for item in inventory.get_items():
        var item_button = create_item_button(item)
        item_button.connect("focus_entered", self, "_on_ItemButton_focus_entered")
        item_button.connect("pressed", self, "_on_ItemButton_pressed", [item])

    _item_grid.initialize()

# warning-ignore:return_value_discarded
    connect("item_bought" , inventory, "trash")
# warning-ignore:return_value_discarded
    connect("item_bought" , player.inventory, "add")

func create_item_button(item):
    var item_button = ItemButton.instance()
    item_button.initialize(item)
    _item_grid.add_child(item_button)
    return item_button

func _on_ItemButton_focus_entered():
    _description_label.text = get_focus_owner().description

func _on_ItemButton_pressed(item):
    var button = get_focus_owner()
    button.grab_focus()
    if player.cash >= item.price:
        emit_signal("item_bought", item)
    ##DO SOMETHING


func _on_Button_pressed():
    queue_free()
    emit_signal("completed")

