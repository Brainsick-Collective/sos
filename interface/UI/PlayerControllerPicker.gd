extends Panel

var choice = 0

var choices = ["controller0", "controller1", "controller2", "controller3", "keyboard0", "keyboard1"]

func get_choice():
    return choices[choice]

func _on_OptionButton_item_selected(id):
    choice = id

func set_label(player_name):
    $HBoxContainer/Label.text = player_name
