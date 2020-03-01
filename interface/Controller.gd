extends AnimatedSprite

func _ready():
# warning-ignore:return_value_discarded
    connect("animation_finished", self, "_on_out_play")
    pass

func _on_out_play():
    if get_animation() == "out":
        play("idle")
