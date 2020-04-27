extends Node

onready var player = $Player
onready var combatant = preload("res://combat/combatants/VapeRider.tscn")

func _ready():
#    player.stats = load("res://game/players/stats/chika.tres")
    var com = combatant.instance()
    player.initialize(0, null, combatant)
    $EquipmentMenu.initialize(player)
        
