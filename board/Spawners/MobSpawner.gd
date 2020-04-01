extends Spawner

class_name MobSpawner

export (bool) var is_boss = false

var on_hold_combatants := []

func _ready():
    for child in $Mobs.get_children():
        child.hide()

    
func _build_scene(player):
    var combat_arena = scene.instance()
    combat_arena.set_fighters(player.combatant, get_mob(), self)
    return combat_arena
    
func get_mob():
    var choice = (randi() % 100) / 100.0
    for child in $Mobs.get_children():
        if choice - child.spawn_rate <= 0:
            var mob = child.duplicate()
            mob.initialize_mob()
            mob.show()
            return mob
        else:
            choice -= child.spawn_rate
    return $Mobs.get_child(0)

# Make generic
func get_actor():
    return get_mob()
    
func get_on_hold():
    return on_hold_combatants

func put_combatants_on_hold(arr):
    for combatant in arr:
        if !on_hold_combatants.has(combatant):
            on_hold_combatants.append(combatant)
            combatant.connect("killed", self, "remove_combatant", [combatant])

func remove_combatant(combatant):
    on_hold_combatants.remove(combatant)
