extends VBoxContainer

var player : Player
onready var EquipGrid = $PlayerInfoPanel/TabContainer/Summary/VBoxContainer/grid

func initialize(_player):
    player = _player
    EquipGrid.set_equipment(player.get_equipment())
