extends Control

var right
var left
onready var LeftOption = $Panel/MarginContainer/HBoxContainer/Left
onready var RightOption = $Panel/MarginContainer/HBoxContainer/Right
signal chosen(choice)
func decide_turns():
	var option = randi() % 2
	right = (option == 1)
	left = !right
	

#left
func _on_Button_pressed(choice):
	if left:
		LeftOption.get_node("Button").hide()
		RightOption.get_node("Button").hide()
		LeftOption.get_node("Label").text = "First"
		RightOption.get_node("Label").text = "Last"
	else:
		LeftOption.get_node("Button").hide()
		RightOption.get_node("Button").hide()
		RightOption.get_node("Label").text = "First"
		LeftOption.get_node("Label").text = "Last"
		$Timer.set_wait_time(3)
		$Timer.start()
		yield($Timer, "timeout")
		if choice == "left":
			emit_signal("chosen", left)
		else:
			emit_signal("chosen", right)
		hide()
		