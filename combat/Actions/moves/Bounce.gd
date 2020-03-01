extends CombatMove

func _ready():
    pass
    
func react(hit):
    hit.reverse = true
    hit.damage = max(1, hit.damage / 2)

#nullify damage
func do_self_effect():
    pass

#reverse damage
func do_enemy_effect(enemy):
    pass
