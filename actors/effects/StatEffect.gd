extends Effect

class_name StatEffect

export(String) var stat
export(int) var buff

func set_target(user, enemy):
    target = user if on_self else enemy

# TODO: handle mods that are multiplative not just additive
func initial_effect():
    target.stats.modifiers[stat] = max(target.stats.modifiers[stat] + buff, 0)

func every_turn_effect():
    pass
    
func end_effect():
    target.stats.modifiers[stat] = max(target.stats.modifiers[stat] - buff, 0)
