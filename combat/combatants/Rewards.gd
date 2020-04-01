extends Node

class_name Rewards


func _ready():
    pass

func give_rewards():
    var children = get_children()
    randomize()
    children.shuffle()
    if get_child_count() > 0:
        for child in children:
            var chance = randf()
            if chance < child.drop_rate:
                print("rewarding " + child.name)
                return child
    return null
