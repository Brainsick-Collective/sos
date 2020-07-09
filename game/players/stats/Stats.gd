extends Resource

class_name Stats

signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal mana_depleted()
signal leveled_up(old, new, points)

var modifiers = {
    "max_health" : 0,
    "max_mana" : 0,
    "strength" : 0,
    "defense" : 0,
    "magic" : 0,
    "speed" : 0
    }

var MAX_LEVEL = 100
export(int) var level = 1
var experience_curve = [ 0, 5, 15, 50, 120, 200, 325, 500, 800, 1250 ]

export(Resource) var job
export(int) var health
export(int) var mana setget set_mana
export(int) var max_health = 0 setget set_max_health, _get_max_health
export(int) var max_mana = 0 setget set_max_mana, _get_max_mana
export(int) var strength = 0 setget set_strength,_get_strength
export(int) var defense = 0 setget set_defense,_get_defense
export(int) var speed = 0 setget set_speed,_get_speed
export(int) var magic = 0 setget ,_get_magic
export(int) var xp = 0 setget set_xp, get_xp
export(int) var kill_xp = 0
var next_level_xp = 6


var is_alive : bool setget ,_is_alive
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
    max_health = max(0, value)

func set_max_mana(value : int):
    if value == null:
        return
    max_mana = max(0, value)
    
func set_speed(value : int):
    if value == null:
        return
    speed = max(0, value)

func set_strength(value : int):
    if value == null:
        return
    strength = max(0, value)

func set_defense(value : int):
    if value == null:
        return
    defense = max(0, value)

func set_xp(value : int):
    xp = value
    var l = level
    var points_gained = 0
    next_level_xp = get_level_xp(l)
    
    while xp >= next_level_xp:
        l+= 1
        if l % 2 == 0:
            points_gained += 2
        next_level_xp = get_level_xp(l)

    if l > level:
        var diff = l - level
        var old = as_mods()
        job.level_up(self, diff)
        var new = as_mods()
        level = l
        _interpolated_level =  float(level) / float(self.MAX_LEVEL)
        reset()
        print(get_signal_connection_list("leveled_up"))
        
        emit_signal("leveled_up",old, new, points_gained)

func get_level_xp(level):
    return round((4 * pow(level, 3)) / 5)

func add_to_modifier(id : String, modifier):
    modifiers[id] += modifier

func add_modifiers(mods : Dictionary):
    for key in mods.keys():
        add_to_modifier(key, mods[key])

func remove_from_modifier(id: String, modifier):
    modifiers[id] = max(0, modifiers[id] - modifier)
    
func remove_modifiers(mods : Dictionary):
    for key in mods.keys():
        remove_from_modifier(key, mods[key])

func _is_alive() -> bool:
    return health > 0

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

func from_dict(dict):
    for key in dict.keys():
        set(key, dict[key])

func as_mods():
    var mods = {}
    for stat in ["strength", "defense", "magic", "speed", "max_health", "max_mana"]:
        mods[stat] = get(stat)
    return mods
