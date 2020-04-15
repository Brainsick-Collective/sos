extends Node

class_name Item

signal amount_changed(amount)
signal depleted()

enum target_types { SELF, ENEMY, ALLY }

export(Texture) var icon
export(String) var display_name = ""
export(String, MULTILINE) var description = ""
export(int) var price = 100
export(target_types) var target_type
export(int) var amount = 1 setget set_amount
export(float, 0,1) var drop_rate = 0

export(bool) var unique = false
export(bool) var usable = true

func use(user):
    if (not usable) or unique:
        return
    if amount == 0:
        return
    self.amount -= 1
    _apply_effect(user)

func set_amount(value):
    amount = max(0, value)
    emit_signal("amount_changed", amount)
    if amount == 0:
        queue_free()
        emit_signal("depleted")

func _apply_effect(user):
    print("Item %s has no apply_effect override" % name)
    
func refresh_after_load():
    pass
