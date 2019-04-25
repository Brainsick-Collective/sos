extends Node

export (NodePath) var board_character
export (Dictionary) var controls = {}
export (int) var id
export (String) var player_name
export (NodePath) var combatant
export (Resource) var stats
export (Resource) var equipment
export (bool) var in_battle

func initialize( new_id, pawn, battler, starting_stats):
	board_character = pawn
	id = new_id - 1
	combatant = battler
	stats = starting_stats.duplicate()
	stats.reset()
	
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
