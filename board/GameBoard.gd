extends TileMap

enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}
enum space_types {empty = -1, SHOP, MAGIC, WILD, ITEM}
var CombatArena = preload("res://combat/CombatArena.tscn")

func initialize():
    $Pathfinder.initialize(self)
    
func request_move(pawn, direction):
    var cell_start = world_to_map(pawn.position)
    var cell_target = find_space(cell_start + direction, direction)
    if cell_target:
        return map_to_world(cell_target)
    
func find_space(tile, direction):
    var value = $Spaces.get_cellv(tile)
    if $Spaces.get_cellv(tile) != space_types.empty:
        return tile
    value = $Path.get_cellv(tile)
    if $Path.get_cellv(tile) == CELL_TYPES.PATH:
        return find_space(tile + direction, direction)
    return null
    
func get_num_spaces(start, end):
    var path_spaces = $Pathfinder.find_path(world_to_map(start),world_to_map(end))
    return path_spaces.size() - 1
    
func get_space_scene(player_pawn):
    #print("player position for encounter: %d") % player.position
    if player_pawn.player.in_battle:
        return player_pawn.player.battle
    var pos = $Spaces.world_to_map(player_pawn.position)
    print("player position id: " + String($Spaces.get_cellv(pos)))
    if $Spaces.get_cellv(pos) == space_types.WILD and  !player_pawn.is_dead:
        print("battle space")
        for character in $Characters.get_children():
            if character.position == player_pawn.position and character != player_pawn and !character.is_dead:
                var combat = CombatArena.instance()
                combat.set_fighters(player_pawn.get_fighter(), character.get_fighter())
                return combat
        return get_random_encounter(player_pawn, pos)
    else: 
        return null
        
func get_random_encounter(player_pawn, pos):
    var combat = CombatArena.instance()
    var monster = MonsterFactory.create_mob(pos)
    print(monster.is_mob())
    combat.set_fighters(player_pawn.get_fighter(), monster)
    return combat
