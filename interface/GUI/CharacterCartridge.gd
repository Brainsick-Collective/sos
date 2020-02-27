extends TextureButton
signal entered
signal exited
onready var hovered = false
onready var orig_pos = rect_position
onready var dest_pos = rect_position + Vector2(50, 0)
func _ready():
    pass

func set_text(text):
    $Label.text = text



func _on_Area2D_mouse_entered():
    print("area entered")
    if hovered == true:
        return
    if rect_position == dest_pos:
        hovered = true
        return
    hovered = true
    emit_signal("entered")

func _on_Area2D_mouse_exited():
    print("area exited")
    if hovered == false:
        return
    if rect_position == orig_pos:
        hovered = false
        return
    hovered = false
    emit_signal("exited")
