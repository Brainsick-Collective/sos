extends Spawner

class_name ShopSpawner

func _ready():
    preview = preview.duplicate()
    pass

func _build_scene(_player):
    var shop = scene.instance()
    shop.set_inventory($ShopInventory)
    return shop
