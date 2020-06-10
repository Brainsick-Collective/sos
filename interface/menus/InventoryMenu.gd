extends Control


## TODO make a class for inventory and extend it for player and shop

export(PackedScene) var ItemButton
var inventory

onready var _item_grid = $Col3/ScrollContainer/Grid
onready var _description_label = $Col3/DescriptionPanel/Label
onready var _prog = $Col2/ProgressStats/grid

var player
func set_inventory(inv):
    inventory = inv

func initialize(_player):
    player = _player
    inventory = player.get_inventory()
    _item_grid.clear()
    for item in inventory.get_non_equip_items():
        var item_button = create_item_button(item)
        item_button.connect("focus_entered", self, "_on_ItemButton_focus_entered")
        item_button.connect("pressed", self, "_on_ItemButton_pressed", [item])

    _item_grid.initialize()
    $Col1/CondensedPlayerPanel.set_condensed(player)
    $Col2/ProgressStats/grid/Exp/Label.text = String(player.stats.xp)
    $Col2/ProgressStats/grid/Next/Label.text = String(player.stats.next_level_xp - player.stats.xp)
    $Col2/ProgressStats/grid/Job/Label.text = player.stats.job.job_name
    $Col2/ProgressStats/grid/NewWorth/Label.text = String(player.get_net_worth())

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
