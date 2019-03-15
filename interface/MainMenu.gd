extends "res://interface/Menu.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var CharacterSelectMenu = preload("res://interface/menus/CharacterSelectMenu.tscn")


func open():
	pass
	
func close():
	get_tree().quit()
	
	pass

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$MenuMargins/Column/QuitButton.connect("pressed", self, "close")
	$MenuMargins/Column/StartButton.connect("pressed",self,"_menu_selected",[CharacterSelectMenu])
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _menu_selected(Menu):
	get_tree().change_scene_to(Menu)
	pass # replace with function body
