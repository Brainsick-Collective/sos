extends Node

onready var Player = preload("res://game/players/Player.tscn")
onready var Clam = preload("res://mobs/Clam.tscn")
onready var mush = preload("res://mobs/MushWiz.tscn")

enum space_types {empty = -1, SHOP, MAGIC, WILD, ITEM}

