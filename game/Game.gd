extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
onready var CombatArena = preload("res://combat/CombatArena.tscn")
var board
func _ready():
	var main_menu = MainMenu.instance()
	main_menu.initialize(self)
	add_child(main_menu)
	
func set_controls():
	$ControlsHandler.initialize($Players)
	for player in $Players.get_children():
		player.board_character.player_id = player.get_id()
		player.controls = $ControlsHandler.get_controls(player.get_id())
	
func enter_encounter(player, encounter):
	remove_child(get_node("Board"))
	var combat = CombatArena.instance()
	print($Players.get_child(player))
	add_child(combat)
	combat.initialize($Players.get_child(player), $Players.get_child(encounter))
	#$ControlsHandler.
	