extends TileMap

class_name Board

enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}
var CombatArena = preload("res://combat/CombatArena.tscn")
var ChoseEncounterPanel = preload("res://interface/GUI/ChoseEncounterPanel.tscn")
export (String) var bgm

func initialize():
    $Pathfinder.initialize(self)
    
func request_move(pawn, direction):
    var cell_start = world_to_map(pawn.position)
    var cell_target = find_space(cell_start + direction, direction)
    if cell_target:
        return cell_target
    
func find_space(tile, direction):
    var space = $Spaces.get_cellv(tile)
    if space != -1:
        return tile
    space = $Path.get_cellv(tile)
    if space == CELL_TYPES.PATH:
        return find_space(tile + direction, direction)
    return null
    
func get_num_spaces(start, end):
    var path_spaces = $Pathfinder.find_path(world_to_map(start),world_to_map(end))
    return path_spaces.size() - 1
    
func get_space_scene(player_pawn):
    print("getting space scene from game board")
    if !player_pawn.player.stats.is_alive:
        return null
    # todo send this to mob spawner?
    var pos = $Spaces.world_to_map(player_pawn.position)
    var mob
    var combatants = []
    var pawns = []
    var spawner
    var player_combatant = player_pawn.player.get_combatant()
    var colliders = player_pawn.get_collisions()
    if colliders:
        for collider in colliders:
            if collider is MobSpawner:
                spawner = collider
                
            # shop, town, or spinner
            elif collider is Spawner:
                return collider._build_scene(player_pawn.player)

            #player or MobPawn
            # turn board character collisions off when dead instead of checking here
            elif collider is Pawn and !pawns.has(collider):
                    pawns.append(collider)
    
    if pawns.empty() and spawner:
        return _build_encounter(player_pawn, spawner.get_mob(), spawner)
    
    elif pawns.size() == 1:
        return _build_encounter(player_pawn, pawns[0], spawner)
    elif pawns.size() > 1 and spawner:
        return _build_chose_encounter(pawns, spawner)

    return null
          
func _build_encounter(pawn, enemy_pawn, spawner):
    var combat = CombatArena.instance()
    combat.setup(pawn.get_combatant(), enemy_pawn.get_combatant())
#    combat.set_spawner(spawner)
    return combat

#TODO fix this
func _build_chose_encounter(pawns, spawner):
    var panel = ChoseEncounterPanel.instance()
    panel.setup(pawns, spawner)
    return panel

func get_pos(keyword):
    for child in $KeyPositions.get_children():
        if child.name == keyword:
            return child.position
