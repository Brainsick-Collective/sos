extends Item

export(PackedScene) var Fireball

func _apply_effect(user):
    var fireball = Fireball.instance()
    user.add_child(fireball)
