extends Node

onready var Shop = preload("res://interface/menus/ShopMenu.tscn")

func _ready():
    pass

func get_shop(_player_pawn, _location):
    var shop = Shop.instance()
    shop.set_inventory($Inventory)
    return shop
