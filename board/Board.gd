extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var START

func initialize(characters):
	for character in characters:
		character.initialize()
		character.set_position(START)
		$Characters.add_child(character)
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	START = $sprite.position
	pass

func _input(event):
	if(event.is_action_pressed("ui_right")):
		$Characters.get_child(0)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
