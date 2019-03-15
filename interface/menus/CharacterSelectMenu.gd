extends "res://interface/Menu.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var left = $Column/Row/Left
onready var right = $Column/Row/Right
onready var character = $Column/Row/Character
onready var Sprites = preload("res://assets/pokemon.tscn")
var sprites
func _ready():
	sprites = Sprites.instance()
	character.set_texture(sprites.get_first().get_texture())


func _input(event):
	if event.is_action_pressed("ui_left"):
		character.set_texture(sprites.last_sprite())
	elif event.is_action_pressed("ui_right"):
		character.set_texture(sprites.next_sprite())
		
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
