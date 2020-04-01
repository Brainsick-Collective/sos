extends Node

func get_item(reference):
    for item in get_children():
        if reference.display_name == item.display_name:
            return item.duplicate()

func get_items():
    return get_children()
