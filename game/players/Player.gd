extends Node

class_name Player

var board_character
var controls = {}
var id
var player_name
var stats
var modded_stats
var combatant_scene
onready var inventory = $Inventory
var actor_name
export (bool) var in_battle
var cash := 0
var is_dead = false
var battle : Node
var death_penalty := 0
var last_heal_space 
var control_scheme_keyword : String
onready var SAVE_KEY = "player_" + name

func initialize(new_id, pawn, battler):
    actor_name = player_name
    board_character = pawn
    id = new_id - 1
    combatant_scene = battler
    var combatant = combatant_scene.instance()
    stats = combatant.stats.duplicate()
    stats.reset()
    cash = 100

func save_resources():
    stats = GameSerializer.save_resource(stats, SAVE_KEY, "stats")

func refresh_after_load():
    ControlsHandler.set_player_controls(self)

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
    var combatant = combatant_scene.instance()
    combatant.initialize(self)
    return combatant

func get_stats_string():
    var string = "Magic: " + String(stats.magic) + "\n" + "Strength: " + String(stats.strength) + "\n" + "Speed: " + String(stats.speed) + "\n" + "Defense: " + String(stats.defense)
    return string
    
func reset_stats():
    stats.reset()
#    combatant.stats.connect("health_depleted", combatant, "on_death")

    
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
