
extends Resource

class_name Stats

signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal mana_depleted()
signal level_up(new_stats)

var modifiers = {}

var health : int
var mana : int setget set_mana
export var max_health : int = 1 setget set_max_health, _get_max_health
export var max_mana : int = 0 setget set_max_mana, _get_max_mana
export var strength : int = 1 setget ,_get_strength
export var defense : int = 1 setget ,_get_defense
export var speed : int = 1 setget ,_get_speed
export var magic : int = 0 setget ,_get_magic
export var xp : int = 0 setget set_xp, get_xp
export var kill_xp: int = 0
var is_alive : bool setget ,_is_alive
export var level : int = 1
export var level_curve : Curve
var required_experience : int
    
func reset():
    health = self.max_health
    mana = self.max_mana
    
func copy() -> Stats:
    var copy = duplicate()
    copy.health = health
    copy.mana = mana
    return copy

func get_required_experience():
    return round(pow(level, 1.8) + level * 4)

func take_damage(hit): # Hit
    var old_health = health
    health -= hit.damage
    health = max(0, health)
    emit_signal("health_changed", health, old_health)
    if health == 0:
        emit_signal("health_depleted")

func level_up():
    level+= 1
    required_experience = get_required_experience()
    
func heal(amount : int):
    var old_health = health
    health = min(health + amount, max_health)
    emit_signal("health_changed", health, old_health)

func set_mana(value : int):
    var old_mana = mana
    mana = max(0, value)
    emit_signal("mana_changed", mana, old_mana)
    if mana == 0:
        emit_signal("mana_depleted")
    
func set_max_health(value : int):
    if value == null:
        return
    max_health = max(1, value)

func set_max_mana(value : int):
    if value == null:
        return
    max_mana = max(0, value)

func set_xp(value : int):
    if value == null:
        return
    if value >= required_experience:
        level_up()
        xp = max(0, value-xp)
    xp = max(0, value)

func add_modifier(id : int, modifier):
    modifiers[id] = modifier

func remove_modifier(id : int):
    modifiers.erase(id)
    
func _is_alive() -> bool:
    return health >= 0

func _get_max_health() -> int:
    return max_health

func _get_max_mana() -> int:
    return max_mana

func _get_strength() -> int:
    return strength
    
func _get_defense() -> int:
    return defense
    
func _get_speed() -> int:
    return speed

func _get_level() -> int:
    return level

func _get_magic() -> int:
    return magic
    
func get_xp() -> int:
    return xp

