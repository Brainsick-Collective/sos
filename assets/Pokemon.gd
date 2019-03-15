extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var index
func initialize():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	index = 0
	pass
func get_first():
	index = 0
	return get_child(0);
	

func next_sprite():
	index = abs((index + 1) % get_child_count())
	return get_child(index).get_texture()
	
func last_sprite():
	index = (index + get_child_count() -1) % get_child_count()
	return get_child(index).get_texture()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
