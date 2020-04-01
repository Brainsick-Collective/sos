extends ColorRect

signal transitioned

func _ready():
    pass

func transition():
    emit_signal("transitioned")
    print("transitioned")
