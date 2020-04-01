extends Resource

class_name Effect

export (String) var name
export (String) var anim_name
export (int) var expiration
export (Array) var tags
export (bool) var on_self = true
var target

func initial_effect():
    pass

func every_turn_effect():
    pass
    
func end_effect():
    pass
    
func apply():
    #play anim here?
    target.apply_effect(self)

func set_target_direct(_target):
    target = _target
