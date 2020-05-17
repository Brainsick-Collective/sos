extends VBoxContainer

var player : Player
onready var EquipGrid = $Row/VBoxContainer/grid

func initialize(_player):
    player = _player
    $Row/TextureRect.texture = player.get_character_image()
    $Row/VBoxContainer/CondensedPlayerPanel.set_condensed(player.get_combatant())
