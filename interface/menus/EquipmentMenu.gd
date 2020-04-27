extends HBoxContainer

onready var view_module = $VBoxContainer/Main/ViewModule
onready var summary_panel = $VBoxContainer/EquipmentSummaryPanel
onready var item_belt = $ItemContainer/Margins/Row/ScrollContainer/ItemBelt

var player

func initialize( _player : Player):
    player = _player
    var stats = player.stats.as_mods()
    var equipment = player.inventory.get_equipment()
    var moves = player.moves
    
    summary_panel.initialize(player)
    item_belt.initialize(equipment, summary_panel)
    view_module.initialize(player)
    item_belt.connect("item_chosen", self, "equip_item")
    
func equip_item(item : Equipment):
    player.equip_item(item)
    view_module.set_item(item)
