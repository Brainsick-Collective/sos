extends Node

class_name Rewards

export()
func _ready():
    pass

func give_rewards():
    var which_reward = rand() % get_children().size
    
