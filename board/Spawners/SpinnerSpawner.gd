extends Spawner

class_name SpinnerSpawner

onready var spinner = preload("res://board/Spinner.tscn")

func _ready():
    pass

func _build_scene(player):
    var new_spinner =  spinner.instance()
    var items = []
    for i in range(5):
        items.append($Inventory.get_items()[randi() % $Inventory.get_child_count()])
    new_spinner.set_items(items)
    new_spinner.connect("item_chosen", player, "recieve_item", [], CONNECT_ONESHOT)
    
    return new_spinner
