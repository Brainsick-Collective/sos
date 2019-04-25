extends "res://interface/Menu.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var CharacterSelectMenu
var game
func open():
	pass
	
func close():
	get_tree().quit()
	
	pass

func initialize(game_node):
	game = game_node
	CharacterSelectMenu = preload("res://interface/menus/CharacterSelectMenu.tscn")
	$MenuMargins/Column/QuitButton.connect("pressed", self, "close")
	$MenuMargins/Column/StartButton.connect("pressed",self,"_menu_selected",[CharacterSelectMenu])




func _menu_selected(Menu):
	var menu = Menu.instance()
	game.add_child(menu)
	menu.initialize(game)
	queue_free()
	pass # replace with function body
