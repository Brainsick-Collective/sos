extends Control


## TODO make a class for inventory and extend it for player and shop

signal item_use_requested(item, actor)
signal completed
export(PackedScene) var ItemButton
var inventory

onready var _item_grid = $Panel/Margin/VBoxContainer/Grid
onready var _description_label = $Panel/Margin/VBoxContainer/DescriptionPanel/Label
onready var _cash_label = $Panel/Margin/VBoxContainer/Label
var player
func set_inventory(inv):
    inventory = inv
    
func initialize():
    _ready()
    #this is sus
    player = inventory.get_parent()
    
    for item in inventory.get_items():
        var item_button = create_item_button(item)
        item_button.connect("focus_entered", self, "_on_ItemButton_focus_entered")
        item_button.connect("pressed", self, "_on_ItemButton_pressed", [item])

    _item_grid.initialize()

    inventory.connect("item_added", self, "create_item_button")
    connect("item_use_requested", inventory, "use")
    _cash_label.text = String(player.cash) + " G"

func create_item_button(item):
    var item_button = ItemButton.instance()
    item_button.initialize(item)
    _item_grid.add_child(item_button)
    return item_button

func _on_ItemButton_focus_entered():
    _description_label.text = get_focus_owner().description

func _on_ItemButton_pressed(item):
    item.use(player)
    var button = get_focus_owner()
    button.grab_focus()
    ##DO SOMETHING
    
func _input(event):
    if event is InputEventKey and ControlsHandler.is_current_player_action(event):
        if event.is_action_pressed("ui_cancel" + String(player.id)):
                emit_signal("completed")
                queue_free()
