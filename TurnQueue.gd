extends Node

#class_name TurnQueue

var active_character

func initialize():
	var battlers = get_battlers()
	battlers.sort_custom(self, 'sort_battlers')
	for battler in battlers:
		battler.raise()
	active_character = get_child(0)
	
func play_turn():
	yield(active_character.play_turn(),"completed")
	var new_index  = active_character.get_index() + 1 % get_child_count()
	active_character = get_child(new_index)
	
static func sort_battlers(a , b):
	return a.stats.speed > b.stats.speed
	
func get_battlers():
	return get_children()