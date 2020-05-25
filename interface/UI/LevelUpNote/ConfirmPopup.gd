extends Panel

signal confirmed(confirmation)

func _on_yes_pressed():
    emit_signal("confirmed", true)
    
func _on_no_pressed():
    emit_signal("confirmed", false)
