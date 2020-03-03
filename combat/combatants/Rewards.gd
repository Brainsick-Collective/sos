extends Node

class_name Rewards


func _ready():
    pass

func give_rewards():
    if get_child_count() > 0:
        var which_reward = randi() % get_children().size()
        return get_child(which_reward)
    else:
        return null
