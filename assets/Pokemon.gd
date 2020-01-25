extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var index
var chika = preload("res://game/players/stats/chika.tres")
var cynd = preload("res://game/players/stats/cynd.tres")
var todo = preload("res://game/players/stats/todo.tres")
var sentret = preload("res://game/players/stats/sentret.tres")

var pokemon_stats = [chika, cynd, todo, sentret]
func initialize():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    index = 0
    pass
func get_first():
    index = 0
    return $Portraits.get_child(0);
    
func get_index():
    return index
func get_stats(character_index) -> Resource:
    var stats = pokemon_stats[character_index]
    stats = stats.copy()
    return stats
    
func next_sprite():
    index = abs((index + 1) % get_child_count())
    return $Portraits.get_child(index).get_texture()
    
func last_sprite():
    index = (index + get_child_count() -1) % get_child_count()
    return $Portraits.get_child(index).get_texture()
    
func get_board_piece():
    return $BoardPiece.get_child(index).get_texture()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
