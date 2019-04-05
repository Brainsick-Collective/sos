extends Node

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
func initialize(players):
	clear_controls()
	set_controls(0)
	for player_ind in players.get_child_count():
		var new_controls = get_controls(player_ind)
		set_new_controls(new_controls)

func add_action(name):
    InputMap.add_action(name)
    
func add_action_key(name, key):
	var event = InputEventKey.new()
	event.scancode = key
	if(!InputMap.has_action(name)):
		add_action(name)
	InputMap.action_add_event(name, event)

func get_controls(id):
	var controls = {}
	for key in controls_set[id]:
		controls[key + String(id)] = controls_set[id][key]
	return controls
	
func set_controls(id):
	for key in controls_set[id]:
			add_action_key(key, controls_set[id][key])
			
func set_new_controls(controls):
	for key in controls.keys():
		add_action_key(key, controls[key])

func clear_controls():
	for action in InputMap.get_action_list("ui_accept"):
		InputMap.action_erase_event("ui_accept",action)
	for action in InputMap.get_action_list("ui_left"):
		InputMap.action_erase_event("ui_left", action)
	for action in InputMap.get_action_list("ui_right"):
		InputMap.action_erase_event("ui_right", action)
	for action in InputMap.get_action_list("ui_up"):
		InputMap.action_erase_event("ui_up", action)
	for action in InputMap.get_action_list("ui_down"):
		InputMap.action_erase_event("ui_down", action)
	for action in InputMap.get_action_list("ui_cancel"):
		InputMap.action_erase_event("ui_cancel", action)
	