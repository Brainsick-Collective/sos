extends Node

export var controls_set ={
    "keyboard0" :
    {
        "ui_left" : KEY_A,
        "ui_right" : KEY_D,
        "ui_up" : KEY_W,
        "ui_down" : KEY_S,
        "ui_accept" : KEY_E,
        "ui_cancel" : KEY_ESCAPE
    },
    "keyboard1" :
    {
        "ui_left" : KEY_LEFT,
        "ui_right" : KEY_RIGHT,
        "ui_up" : KEY_UP,
        "ui_down" : KEY_DOWN,
        "ui_accept" : KEY_ENTER,
        "ui_cancel" : KEY_BACKSPACE
    },
    "controller" :
    {
        "ui_accept" : JOY_BUTTON_0,
        "ui_cancel" : JOY_BUTTON_3,
        "ui_right" : JOY_BUTTON_15,
        "ui_left" : JOY_BUTTON_14,
        "ui_down" : JOY_BUTTON_13,
        "ui_up" : JOY_BUTTON_12,
        "ui_select" : JOY_BUTTON_3
    }
}

var key_strings = [
        "ui_left",
        "ui_right",
        "ui_up",
        "ui_down",
        "ui_accept",
        "ui_cancel"
   ]

var controller_map = {
    "ui_accept" : JOY_BUTTON_0,
    "ui_cancel" : JOY_BUTTON_3,
    "ui_right" : JOY_BUTTON_15,
    "ui_left" : JOY_BUTTON_14,
    "ui_down" : JOY_BUTTON_13,
    "ui_up" : JOY_BUTTON_12,
    "ui_select" : JOY_BUTTON_3
   }

var control_lookup_map ={}
var current_player = 0
var players : Array

func initialize(_players):
    clear_controls()
    players = _players.get_children()
    
    for player in players:
        set_controls_by_keyword(player.id, player.control_scheme_keyword)
#    for player_ind in players.get_child_count():
#        var new_controls = get_controls(player_ind)
#        set_new_controls(new_controls)
#        for control in new_controls:
#            control_lookup_map[new_controls[control]] = player_ind

func set_player_controls(player : Player):
    set_controls_by_keyword(player.id, player.control_scheme_keyword)

func add_action(action):
    InputMap.add_action(action)
    
func add_action_key(action, key):
    var event = InputEventKey.new()
    event.scancode = key
    if(!InputMap.has_action(action)):
        add_action(action)
    InputMap.action_add_event(action, event)

func add_pad_action(action, button, id):
    var event = InputEventJoypadButton.new()
    event.button_index = button
    event.device = int(id)
    if(!InputMap.has_action(action)):
        add_action(action)
    InputMap.action_add_event(action, event)

func set_controls_by_keyword(id : int, keyword : String):
    if keyword.begins_with("keyboard"):
        set_controls_by_keyboard_id(id, keyword)
    elif keyword.begins_with("controller"):
        set_controls_by_controller_id(id, keyword.trim_prefix("controller"))
    else:
        print("player control scheme absent or invalid")
        return null
    
        
    
    
func set_controls_by_keyboard_id(id, keyboard_id):
    var controls = get_keyboard_controls(id, keyboard_id)
    for key in controls:
        add_action_key(key, controls[key])
        control_lookup_map[controls[key]] = id
        

func set_controls_by_controller_id(id, controller_id):
    var controls = {}
    for key in controls_set["controller"]:
        controls[key + String(id)] = controls_set["controller"][key]
    for key in controls:
        add_pad_action(key, controls[key], controller_id)
    
func get_keyboard_controls(id, keyboard_id):
    var controls = {}
    for key in controls_set[keyboard_id]:
        controls[key + String(id)] = controls_set[keyboard_id][key]
    return controls
            
func set_new_controls(controls):
    for key in controls.keys():
        add_action_key(key, controls[key])
        
func clear_player_controls(ind):
    for string in key_strings:
        InputMap.action_erase_events(string + String(ind))

func clear_controls():
        InputMap.action_erase_events("ui_accept")
        InputMap.action_erase_events("ui_left")
        InputMap.action_erase_events("ui_right")
        InputMap.action_erase_events("ui_up")
        InputMap.action_erase_events("ui_down")
        InputMap.action_erase_events("ui_cancel")

func give_player_ui_control(player):

    if player.control_scheme_keyword.begins_with("keyboard"):
        var controls = controls_set[player.control_scheme_keyword]
        for key in controls:
            add_action_key(key, controls[key])
    else: 
        var controls = controls_set["controller"]
        for action in controls:
            add_pad_action(action, controls[action], 
                int(player.control_scheme_keyword.trim_prefix("controller")))

func which_player(event : InputEvent):
    if event is InputEventKey and control_lookup_map.has(event.scancode):
            return control_lookup_map[event.scancode]  
    elif event is InputEventJoypadButton:
        for player in players:
            if player.control_scheme_keyword == "controller" + String(event.device):
                return player.id
    return -1
    
func is_current_player_action(event : InputEvent):
    return which_player(event) == current_player

func get_current_player_direction():
    var move_direction = Vector2(0,0)

    var dpad_left = process_input_for_players("ui_left", [current_player])
    var dpad_right = process_input_for_players("ui_right", [current_player])
    var dpad_up  = process_input_for_players("ui_up", [current_player])
    var dpad_down = process_input_for_players("ui_down", [current_player])

    if dpad_left:
        move_direction += Vector2(-1,0)
    if dpad_right:
        move_direction += Vector2(1,0)
    if dpad_up:
        move_direction += Vector2(0,-1)
    if dpad_down:
        move_direction += Vector2(0,1)
        
    return move_direction

func is_action_pressed_by_current_player(event, action : String):
    return is_action_pressed_by_players(event,action, [current_player])

func is_action_pressed_by_players(event , action : String, players: Array):
    
    for player in players:
        var id = -1
        
        if player is int:
            id = player
        else:
            id = player.id 

        if id == -1:
            continue
        if (InputMap.has_action(action + String(id))
            and event.is_action_pressed(action + String(id))):
            return true
        
    return false
    
func process_input_for_players(action : String, players : Array):
    for player in players:
        var id = -1
        if player is int:
            id = player
        else:
            id = player.id
        if id == -1:
            continue
        if Input.is_action_pressed(action + String(id)):
            return true
    return false
