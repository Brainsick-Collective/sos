extends Node

onready var Shop = preload("res://interface/menus/ShopMenu.tscn")

func _ready():
    pass

func get_shop(player_pawn, location):
    var shop = Shop.instance()
    shop.set_inventory($Inventory)
    return shop
