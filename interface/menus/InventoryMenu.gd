extends Control


## TODO make a class for inventory and extend it for player and shop

export(PackedScene) var ItemButton
var inventory

onready var _item_grid = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/ScrollContainer/Grid
onready var _description_label = $Margin/VBoxContainer/DescriptionPanel/Label
onready var _cash_label = $Margin/VBoxContainer/HBoxContainer/VBoxContainer/Label
var player
func set_inventory(inv):
    inventory = inv

func initialize(player):
    inventory = player.get_inventory()
    
    for item in inventory.get_items():
        var item_button = create_item_button(item)
        item_button.connect("focus_entered", self, "_on_ItemButton_focus_entered")
        item_button.connect("pressed", self, "_on_ItemButton_pressed", [item])

    _item_grid.initialize()

    inventory.connect("item_added", self, "create_item_button")

func create_item_button(item):
    var item_button = ItemButton.instance()
    item_button.initialize(item)
    _item_grid.add_child(item_button)
    return item_button

func _on_ItemButton_focus_entered():
    _description_label.text = get_focus_owner().description

func _on_ItemButton_pressed(item):
    if item is Equipment:
        player.equip_item(item)
    else:
        item.use(player)
    var button = get_focus_owner()
    button.grab_focus()
    ##DO SOMETHING
