extends Node

export (NodePath) var board_character
export (Dictionary) var controls = {}
export (int) var id
export (String) var player_name

func initialize( new_id, character):
	board_character = character
	id = new_id - 1
	
func set_controls(controls):
	self.controls = controls
	
func get_id():
	return id
