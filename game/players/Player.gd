extends Node

export (NodePath) var board_character
export (Dictionary) var controls = {}
export (int) var id
export (String) var player_name
export (NodePath) var combatant

func initialize( new_id, pawn, battler):
	board_character = pawn
	id = new_id - 1
	combatant = battler
	
func set_controls(controls):
	self.controls = controls
	
func get_id():
	return id
	
func get_board_character():
	return board_character
	
func get_combatant():
	return combatant
