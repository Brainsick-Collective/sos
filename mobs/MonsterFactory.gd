extends Node

onready var Player = preload("res://game/players/Player.tscn")
var GM
func _ready():
    GM = Player.instance()
    GM.player_name = "Mob1"
    GM.id = -1
    pass
    
func create_mob(location_code):
    var sentret = preload("res://mobs/Sentret.tscn")
    var combatant = sentret.instance()
    combatant.player = GM
    combatant.initialize_mob(load("res://game/players/stats/sentret.tres"))
    GameVariables.set_default_moves(combatant)
    print(combatant.is_mob())
    return combatant
