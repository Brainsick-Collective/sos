extends HBoxContainer

enum {WEAPON, OFFHAND, OFFENSIVE_MAGIC, DEFENSIVE_MAGIC}

var player

onready var action_display = $BAMargins/BattleActionsDisplay

func initialize(_player):
    player = _player
    
    for item in player.get_equipped_items():
        set_item(item)
    
    action_display.initialize(player)
        
func set_item(item : Item):
    if item == null:
        print("null item")
        return
    
    var type = item.type
    
    for slot in $Margins/Column.get_children():
        if slot.equipment_type == item.type:
            var old_item = slot.active_item
            if old_item and old_item.move:
                player.revert_move(old_item.move)
                action_display.set_option(player.moves[old_item.move.phase][old_item.move.type])
            slot.set_item(item)
            if item.move:
                action_display.set_move(item.move)
