extends Node

var current_player
var attack_res = load("res://combat/Actions/moves/Attack.tres")
var defend_res = load("res://combat/Actions/moves/Defend.tres")
var parry_res = load("res://combat/Actions/moves/Parry.tres")
var rally_res = load("res://combat/Actions/moves/Rally.tres")
var giveup_res = load("res://combat/Actions/moves/GiveUp.tres")
var strike_res = load("res://combat/Actions/moves/Strike.tres")
var zap_res = load("res://combat/Actions/moves/Zap.tres")
var ward_res = load("res://combat/Actions/moves/Ward.tres")

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
	
func set_default_moves(combatant):
	var defaults = {}
	var offense = {}
	var defense = {}
	offense["normal"] = attack_res
	offense["magic"] = zap_res
	offense["special"] = strike_res
	offense["effect"] = rally_res
	defense["normal"] = defend_res
	defense["magic"] = ward_res
	defense["special"] = parry_res
	defense["effect"] = giveup_res
	defaults["offense"] = offense
	defaults["defense"] = defense
	combatant.set_moves_from_dict(defaults)
	
	
#		var attack = CombatAction.new()
#	attack.move = attack_res
#	var defend = CombatAction.new()
#	defend.move = defend_res
#	var zap = CombatAction.new()
#	zap.move = zap_res
#	var rally = CombatAction.new()
#	rally.move = rally_res
#	var giveup = CombatAction.new()
#	giveup.move = giveup_res
#	var ward = CombatAction.new()
#	ward.move = ward_res
#	var parry = CombatAction.new()
#	parry.move = parry_res
#	var strike = CombatAction.new()
#	strike.move = strike_res