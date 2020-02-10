extends Node

export (NodePath) var board_character
export (Dictionary) var controls = {}
export (int) var id
export (String) var player_name
export (NodePath) var combatant
export (Resource) var stats
var inventory
var equipment
export (bool) var in_battle
var cash := 0
var is_dead = false
var battle


func initialize( new_id, pawn, battler):
    board_character = pawn
    id = new_id - 1
    combatant = battler
    stats = combatant.stats
    stats.reset()
    combatant.connect("killed", pawn, "on_killed")
    cash = 100
    inventory = $Inventory
    
func get_inventory():
    return get_node("Inventory")

func set_controls(controls):
    self.controls = controls
    
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
    
func on_death():
    pass
    
func on_revive():
    board_character.on_revive()
    is_dead = false
