extends Node

class_name Player

export (NodePath) var board_character
export (Dictionary) var controls = {}
export (int) var id
export (String) var player_name
export (NodePath) var combatant
export (Resource) var stats
var modded_stats

var inventory
var actor_name
export (bool) var in_battle
var cash := 0
var is_dead = false
var battle : Node
var death_penalty := 0
var last_heal_space 


func initialize( new_id, pawn, battler):
    actor_name = player_name
    board_character = pawn
    id = new_id - 1
    combatant = battler
    stats = combatant.stats.duplicate()
    stats.reset()
    combatant.connect("killed", board_character, "on_killed")
    inventory = $Inventory
    cash = 100
    
func get_inventory():
    return $Inventory

func receive_item(item):
    if item:
        $Inventory.add(item)
    
func set_controls(_controls):
    controls = _controls
    
func get_id():
    return id
    
func get_board_character():
    return board_character
    
func get_combatant():
    return combatant

func get_stats_string():
    var string = "Magic: " + String(stats.magic) + "\n" + "Strength: " + String(stats.strength) + "\n" + "Speed: " + String(stats.speed) + "\n" + "Defense: " + String(stats.defense)
    return string
    
func reset_stats():
    print("reseting stats")
    print(String(stats.health))
    print(String(combatant.stats.health))
    stats.copy(combatant.stats)
    stats.reset()
    combatant.stats.reset()
    combatant.stats.connect("health_depleted", combatant, "on_death")
    print(String(stats.health)) 
    print(String(combatant.stats.health))
    
func apply_effect(effect):
    $EffectsHolder.add_effect(effect)
    if board_character.visible:
        # play anim?
        pass

func on_death():
    pass
    
func on_revive():
    board_character.on_revive()
    is_dead = false

func _on_Inventory_item_added(item):
    if item is Equipment:
        stats.add_modifiers(item.get_stat_mods())

func _on_Inventory_item_removed(item):
    if item is Equipment:
        stats.remove_modifiers(item.get_stat_mods())
