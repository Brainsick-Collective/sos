extends Resource

var health 
var mana  setget set_mana
export (int) var max_health = 1 setget set_max_health, _get_max_health
export (int) var max_mana = 0 setget set_max_mana, _get_max_mana
export (int) var strength = 1 setget ,_get_strength
export (int) var defense = 1 setget ,_get_defense
export (int) var speed = 1 setget ,_get_speed

func reset():
	health = self.max_health
	mana = self.max_mana
	
func copy():
	"""
	Perform a more accurate duplication, as normally Resource duplication
	does not retain any changes, instead duplicating from what's registered
	in the ResourceLoader
	"""
	var copy = duplicate()
	copy.health = health
	copy.mana = mana
	return copy

func take_damage(hit):
	var old_health = health
	health -= hit.damage
	health = max(0, health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")

func heal(amount):
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health)

func set_mana(value):
	var old_mana = mana
	mana = max(0, value)
	emit_signal("mana_changed", mana, old_mana)
	if mana == 0:
		emit_signal("mana_depleted")
	
func set_max_health(value):
	if value == null:
		return
	max_health = max(1, value)

func set_max_mana(value):
	if value == null:
		return
	max_mana = max(0, value)

func add_modifier(id, modifier):
	modifiers[id] = modifier

func remove_modifier(id):
	modifiers.erase(id)
	
func _is_alive():
	return health >= 0

func _get_max_health():
	return max_health

func _get_max_mana():
	return max_mana

func _get_strength():
	return strength
	
func _get_defense():
	return defense
	
func _get_speed():
	return speed

func _get_level():
	return level
