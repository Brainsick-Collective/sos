extends Node

var current_player
export var controls_set =[
{
		"ui_left" : KEY_A,
		"ui_right" : KEY_D,
		"ui_up" : KEY_W,
		"ui_down" : KEY_S,
		"ui_accept" : KEY_E,
		"ui_cancel" : KEY_ESCAPE
	},
	{
		"ui_left" : KEY_LEFT,
		"ui_right" : KEY_RIGHT,
		"ui_up" : KEY_UP,
		"ui_down" : KEY_DOWN,
		"ui_accept" : KEY_ENTER,
		"ui_cancel" : KEY_DELETE
	}
]

func set_current_player(id):
	current_player = id
	
func get_current_player():
	return current_player

func get_controls(id):
	return controls_set[id]