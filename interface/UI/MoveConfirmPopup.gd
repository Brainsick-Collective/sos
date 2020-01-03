extends Popup

signal completed(isYes)
onready var Yes = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Yes
onready var No = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/No

func _ready():
    Yes.grab_focus()
    
func show():
    .show()
    Yes.grab_focus()
    

func _on_Yes_pressed():
    emit_signal("completed", true)


func _on_No_pressed():
    emit_signal("completed", false)
