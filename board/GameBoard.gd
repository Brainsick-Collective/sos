extends TileMap

enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}
enum space_types {empty = -1, SHOP, MAGIC, WILD, ITEM}
var CombatArena = preload("res://combat/CombatArena.tscn")
var ChoseEncounterPanel = preload("res://interface/GUI/ChoseEncounterPanel.tscn")

func initialize():
    $Pathfinder.initialize(self)
    
func request_move(pawn, direction):
    var cell_start = world_to_map(pawn.position)
    var cell_target = find_space(cell_start + direction, direction)
    if cell_target:
        return map_to_world(cell_target)
    
func find_space(tile, direction):
    var space = $Spaces.get_cellv(tile)
    if space != space_types.empty:
        return tile
    space = $Path.get_cellv(tile)
    if space == CELL_TYPES.PATH:
        return find_space(tile + direction, direction)
    return null
    
func get_num_spaces(start, end):
    var path_spaces = $Pathfinder.find_path(world_to_map(start),world_to_map(end))
    return path_spaces.size() - 1
    
func get_space_scene(player_pawn):
    if !player_pawn.player.stats.is_alive:
        return null
        
    var pos = $Spaces.world_to_map(player_pawn.position)
    var mob
    var combatants = []
    var spawner
    var colliders = player_pawn.get_collisions()
    if colliders:
        print("colliders")
        for collider in colliders:
            print(collider.name)
            if collider is MobSpawner:
                mob = collider.get_mob()
                spawner = collider
                var on_hold = collider.on_hold_combatants
                if !on_hold.empty():
                    for combatant in on_hold:
                        if !combatants.has(combatant) and combatant != player_pawn.get_actor():
                            combatants.append(combatant)
            elif collider is Spawner:
                return collider._build_scene(player_pawn.player)
            else:
                if collider is BoardCharacter:
                    if collider.player.stats.is_alive and !combatants.has(collider.player.combatant):
                        combatants.append(collider.player.combatant)
    if not combatants:
        if mob:
            return _build_encounter(player_pawn, mob, spawner)
    elif combatants.size() == 1:
        return _build_encounter(player_pawn, combatants[0], spawner)
    else:
        return _build_chose_encounter(combatants, spawner)

    return null
          
func _build_encounter(pawn, enemy, spawner):
    var combat = CombatArena.instance()
    combat.setup(pawn.get_actor(), enemy,spawner)
#    combat.set_spawner(spawner)
    return combat

func _build_chose_encounter(combatants, spawner):
    var panel = ChoseEncounterPanel.instance()
    panel.setup(combatants, spawner)
    return panel
    
func get_location(player_pawn, space_type):
  if space_type == space_types.MAGIC:
    return ShopFactory.get_shop(player_pawn,space_type)
