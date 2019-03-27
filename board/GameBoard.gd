extends TileMap

enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}

func initialize():
	$Pathfinder.initialize(self)
	
func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = find_space(cell_start + direction, direction)
	if cell_target:
		return map_to_world(cell_target)
	
func find_space(tile, direction):
	var value = $Spaces.get_cellv(tile)
	if $Spaces.get_cellv(tile) == SPACE:
		return tile
	value = $Path.get_cellv(tile)
	if $Path.get_cellv(tile) == PATH:
		return find_space(tile + direction, direction)
	return null
	
func get_num_spaces(start, end):
	var path_spaces = $Pathfinder.find_path(world_to_map(start),world_to_map(end))
	return path_spaces.size() - 1