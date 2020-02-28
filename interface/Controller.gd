extends AnimatedSprite

func _ready():
    connect("animation_finished", self, "_on_out_play")
    pass

func _on_out_play():
    if get_animation() == "out":
        play("idle")
