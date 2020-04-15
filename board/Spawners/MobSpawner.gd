extends Spawner

class_name MobSpawner

export (bool) var is_boss = false
onready var MobPawn = preload("res://board/pawns/MobPawn.tscn")

func _ready():
    for child in $Mobs.get_children():
        child.hide()
    
func _build_scene(player):
    var combat_arena = scene.instance()
    combat_arena.set_fighters(player.combatant, get_mob(), self)
    return combat_arena

func spawn_pawn(mob = $Mobs.get_child(0)):
    var pawn = MobPawn.instance()
    add_child(pawn)
    pawn.initialize(self, mob, null)
    return pawn
    
func get_mob():
    var choice = (randi() % 100) / 100.0
    var mob
    for child in $Mobs.get_children():
        if choice - child.spawn_rate <= 0:
            mob = child
        else:
            choice -= child.spawn_rate
    if !mob:      
        mob = $Mobs.get_child(0)
    var pawn = spawn_pawn(mob)
    return pawn

# Make generic
func get_actor():
    return get_mob()

