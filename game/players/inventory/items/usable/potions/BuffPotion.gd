extends Item

class_name BuffPotion

export(Resource) var effect
 
func _apply_effect(user):
    assert(user is Player)
    effect.set_target_direct(user)
    user.add_buff(effect)
    
