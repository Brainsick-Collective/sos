extends Node

"""
Finds the path between two points using AStar, in grid coordinates
"""

var astar = AStar2D.new()

var _map_offset
var _path_tiles
var _points = []
enum CELL_TYPES {PATH, SPACE, GRASS, BUSH, DIRT}

func initialize(grid):

    _map_offset = grid.get_used_rect().size
    
    var path_cells = grid.get_node("Path").get_used_cells_by_id(CELL_TYPES.PATH)

    # Find all walkable cells and store them in an array
    for point in path_cells:
        var point_index = calculate_point_index(point)
        astar.add_point(point_index, point)
    
    # Loop through all walkable cells and their neighbors
    # to connect the points
    for point in path_cells: 
        var point_index = calculate_point_index(point)
        for local_y in range(3):
            for local_x in range(3):
                var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
                var point_relative_index = calculate_point_index(point_relative)
                if point_relative == point:
                    continue
                if not astar.has_point(point_relative_index):
                    continue
                if point_index == point_relative_index:
                    print("what")
                astar.connect_points(point_index, point_relative_index, true)
    _points = astar.get_points()

func calculate_point_index(point):
    point += _map_offset
    return int(point.x + _map_offset.x * point.y)

func find_path(start, end):
    """
    Returns an array of cells that connect the start and end positions
    in grid coordinates
    """
    var start_index = calculate_point_index(start)
    var end_index = calculate_point_index(end)
    return astar.get_point_path(start_index, end_index)

