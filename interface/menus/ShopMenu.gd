extends Control

class_name ShopMenu

## TODO make a class for inventory and extend it for player and shop

export(PackedScene) var ItemButton
var inventory
signal item_bought(item)
signal completed
var player
var curr_item
var last_button

enum {EXIT, BUY, SELL}
var current_action

onready var _item_grid = $Column/Row/ItemList/Margin/Grid
onready var _description_label = $Column/Description/Margin/Label

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
    item_button.initialize(item, true)
    item_button.disabled = false
    _item_grid.add_child(item_button)
    return item_button

func _on_ItemButton_focus_entered():
    _description_label.DIALOG = get_focus_owner().description
    _description_label.play_and_hold()

func _on_ItemButton_pressed(item):
    curr_item = item
    last_button = get_focus_owner()
    current_action = BUY
    _show_confirm()
    
func _buy_item():
    if player.cash >= curr_item.price:
        emit_signal("item_bought", curr_item)
        player.cash -= curr_item.price
    ##DO SOMETHING


func _show_confirm():
    $ConfirmPopup.show()
    $ConfirmPopup/VBoxContainer/yes.grab_focus()
    match current_action:
        EXIT:
            _description_label.set_and_play("are you done shopping?")
        BUY:
            _description_label.set_and_play("So you want to buy a " + curr_item.name + "?")
    

func _input(event):
    if ControlsHandler.is_action_pressed_by_current_player(event, "ui_cancel"):
        current_action = EXIT
        _show_confirm()
        
func _process(_delta):
    $Panel/HBoxContainer/cash.text = String(player.cash) + " G"
func _do_action():
    match current_action:
        EXIT:
            queue_free()
            emit_signal("completed", null)
        BUY:
            _buy_item()
            $ConfirmPopup.hide()
            _focus_last()
        

func _on_yes_pressed():
    _do_action()


func _on_no_pressed():
    $ConfirmPopup.hide()
    _focus_last()
    
func _focus_last():
    if last_button:
        last_button.grab_focus()
    elif _item_grid.has_child(0):
        _item_grid.get_child(0).grab_focus()
