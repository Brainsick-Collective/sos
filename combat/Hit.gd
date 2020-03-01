"""
Base object that represents an attack or a hit
"""

class_name Hit

enum move_types { empty = -1, normal, special, magic, effect }
var damage = 0 setget _set_damage, _get_damage
var target setget _set_target, _get_target
var type  setget _set_type, _get_type
var reverse = false
# var effect : StatusEffect = StatusEffect.new()


func _set_damage(dg: int):
    damage = dg
    
func _get_damage():
    return damage
    
func _set_target(tar):
    target = tar
    
func _get_target():
    return target
func _set_type(new_type):
    type = new_type
func _get_type():
    return type
    
func execute():
    # do rand chance based on accuracy, if success then take damage
    target.take_damage(self)
