extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
var board
func _ready():
	var main_menu = MainMenu.instance()
	main_menu.initialize(self)
	add_child(main_menu)
	

