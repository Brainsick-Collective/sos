extends Node

onready var Player = preload("res://game/players/Player.tscn")
onready var Clam = preload("res://mobs/Klam.tscn")
onready var mush = preload("res://mobs/MushWiz.tscn")

enum space_types {empty = -1, SHOP, MAGIC, WILD, ITEM}
var GM

func _ready():
    GM = Player.instance()
    GM.player_name = "Mob1"
    GM.id = -1
    
func create_mob(location_code):
    if location_code == space_types.WILD:
        return init_mob(Clam.instance())
    elif location_code == space_types.SHOP:
        return init_mob(mush.instance())
    return null

func init_mob(mob : Mob):
    mob.player = GM
    mob.initialize_mob()
    return mob
