extends Item

class_name Equipment

enum equip_type {WEAPON, OFFHAND, OFFENSIVE_MAGIC, DEFENSIVE_MAGIC}

export (equip_type) var type
export(int) var STRENGTH = 0
export(int) var MAGIC = 0
export(int) var DEFENSE = 0
export(int) var SPEED = 0
export(int) var HEALTH = 0
export(int) var MANA = 0
export(bool) var equipped
export(Resource) var move

func hit_effect(hit):
    pass

func field_effect():
    pass

func mod_stats(stats : Stats):
    stats.strength += STRENGTH
    stats.magic += MAGIC
    stats.defense += DEFENSE
    stats.speed += SPEED
    stats.max_health += HEALTH
    stats.max_mana += MANA

func get_stat_mods():
    var stats = Stats.new()
    mod_stats(stats)
    return stats.as_mods()
