extends Resource

class_name Stats

signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal mana_depleted()
signal leveled_up(note)

var modifiers = {
    "max_health" : 0,
    "max_mana" : 0,
    "strength" : 0,
    "defense" : 0,
    "magic" : 0,
    "speed" : 0
    }
var MAX_LEVEL = 100
var health : int
var mana : int setget set_mana
export(int) var max_health = 0 setget set_max_health, _get_max_health
export(int) var max_mana = 0 setget set_max_mana, _get_max_mana
export(int) var strength = 0 setget set_strength,_get_strength
export(int) var defense = 0 setget set_defense,_get_defense
export(int) var speed = 0 setget set_speed,_get_speed
export(int) var magic = 0 setget ,_get_magic
export(int) var xp = 0 setget set_xp, get_xp
export(int) var kill_xp = 0


var is_alive : bool setget ,_is_alive
export(int) var level = 1
export(Curve) var max_health_curve
export(Curve) var max_mana_curve
export(Curve) var strength_curve
export(Curve) var defense_curve
export(Curve) var speed_curve
var experience_curve = [ 0, 5, 15, 50, 120, 200, 325, 500, 800, 1250 ]
var required_experience : int
var _interpolated_level
var player_id : int

var level_up_note = preload("res://interface/UI/LevelUpNote.tscn")

func reset():
    health = _get_max_health()
    mana = _get_max_mana()

    
func copy(other_stats):
    max_health = other_stats.max_health
    max_mana = other_stats.max_mana
    health = other_stats.health
    mana = other_stats.mana
    strength = other_stats.strength
    speed = other_stats.speed
    magic = other_stats.magic
    defense = other_stats.defense
    xp = other_stats.xp

func get_required_experience():
    return round(pow(level, 1.8) + level * 4)

func take_damage(hit): # Hit
    var old_health = health
    health -= hit.damage
# warning-ignore:narrowing_conversion
    health = max(0.0, health)
    emit_signal("health_changed", health, old_health)
    if health == 0:
        emit_signal("health_depleted")

func level_up():
    set_max_health(int(max_health_curve.interpolate_baked(_interpolated_level)))
    set_max_mana(int(max_mana_curve.interpolate_baked(_interpolated_level)))
    set_strength(int(strength_curve.interpolate_baked(_interpolated_level)))
    set_defense(int(defense_curve.interpolate_baked(_interpolated_level)))
    set_speed(int(speed_curve.interpolate_baked(_interpolated_level)))

func heal(amount : int):
    var old_health = health
# warning-ignore:narrowing_conversion
    health = min(health + amount, _get_max_health())
    emit_signal("health_changed", health, old_health)

func set_mana(value : int):
    var old_mana = mana
# warning-ignore:narrowing_conversion
    mana = max(0.0, value)
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
    
func set_speed(value : int):
    if value == null:
        return
    speed = max(1, value)

func set_strength(value : int):
    if value == null:
        return
    strength = max(1, value)

func set_defense(value : int):
    if value == null:
        return
    defense = max(1, value)

func set_xp(value : int):
    xp = value
    var l = level    
    while l + 1 < self.MAX_LEVEL && xp >= experience_curve[l + 1]:
        l += 1
    if l > level:
        var note = level_up_note.instance()
        note.initialize(player_id)
        note.set_old_stats(self)
        level = l
        _interpolated_level =  float(level) / float(self.MAX_LEVEL)
        level_up()
        kill_xp = int(experience_curve[level] / 2)
        reset()
        note.set_new_stats(self)
        note.play_text()
        emit_signal("leveled_up", note)

func add_to_modifier(id : String, modifier):
    modifiers[id] += modifier

func add_modifiers(mods : Dictionary):
    for key in mods.keys():
        add_to_modifier(key, mods[key])

func remove_modifier(id: String, modifier):
    modifiers[id] = max(0, modifiers[id] - modifier)
    
func _is_alive() -> bool:
    return health >= 0

func _get_max_health() -> int:
    return max_health + modifiers["max_health"]

func _get_max_mana() -> int:
    return max_mana + modifiers["max_health"]

func _get_strength() -> int:
    return strength + modifiers["strength"]
    
func _get_defense() -> int:
    return defense + modifiers["defense"]
    
func _get_speed() -> int:
    return speed + modifiers["speed"]

func _get_level() -> int:
    return level

func _get_magic() -> int:
    return magic + modifiers["magic"]
    
func get_xp() -> int:
    return xp

func as_mods():
    var mods = {}
    for stat in ["strength", "defense", "magic", "speed", "max_health", "max_mana"]:
        mods[stat] = get(stat)
    return mods
