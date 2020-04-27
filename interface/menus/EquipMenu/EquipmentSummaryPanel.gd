extends Panel

var player
onready var stats_row = $Margins/Row/Column/Row
onready var StatMod = preload("res://interface/menus/EquipMenu/StatMod.tscn")

func initialize(_player : Player):
    player = _player

func set_item(item):
    $Margins/Row/Column/Row/NameLabel.text = item.name
    $Margins/Row/Column/Description.text = item.description
    if item.equipped:
        return
    
    for child in stats_row.get_children():
        if child == stats_row.get_node("NameLabel"):
            continue
        else:
            stats_row.remove_child(child)
    
    var old_mods = player.stats.modifiers.duplicate()
    var old_item = player.equip_item(item)
    var new_mods = player.stats.modifiers.duplicate()
    
    for mod_key in old_mods.keys():
        if old_mods[mod_key] != new_mods[mod_key]:
            var mod = StatMod.instance()
            stats_row.add_child(mod)
            mod.initialize(mod_key, old_mods[mod_key], new_mods[mod_key])
    
    if old_item:
        player.equip_item(old_item)
    else:
        player.unequip_item(item)
    var reverted_mods = player.stats.modifiers.duplicate() 
    for key in reverted_mods.keys():
        if reverted_mods[key] != old_mods[key]:
            print("wtf mate")

