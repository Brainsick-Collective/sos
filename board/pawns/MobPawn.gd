extends BoardCharacter

class_name MobPawn

var spawner
var mob
var stats

func initialize(_spawner, _mob, _2):
    spawner = _spawner
    mob = _mob
    stats = mob.stats.duplicate()
    stats.reset()
    stats.connect("health_depleted", self, "delete_self", [], CONNECT_DEFERRED)
    
    
func get_combatant():
    var combatant = mob.duplicate()
    combatant.stats = stats
    combatant.initialize_mob()
    combatant.show()
    return combatant

func delete_self():
    queue_free()
