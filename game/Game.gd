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
	board = get_node("Board")
	if encounter != null:
		print("fight between " + String(player) + " " + String(encounter))
		remove_child(get_node("Board"))
		var combat = CombatArena.instance()
		add_child(combat)
		if $Players.get_child(encounter).board_character.death_penalty == 0:
			combat.initialize($Players.get_child(player).combatant, $Players.get_child(encounter).combatant)
			yield(combat, "combat_finished")
			add_child(board)
			for player in $Players.get_children():
				if player.stats.health == 0:
					board.death_respawn(player)
	board.next_turn()