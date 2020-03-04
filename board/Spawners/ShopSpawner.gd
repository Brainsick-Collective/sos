extends Spawner

class_name ShopSpawner

func _ready():
    pass

func _build_scene(player):
    var shop = scene.instance()
    shop.set_inventory($Inventory)
    return shop
