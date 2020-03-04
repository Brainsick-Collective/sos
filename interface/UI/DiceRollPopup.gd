extends NinePatchRect

signal completed(turn_size)
var num = 0
var countdown = 0
const COUNTDOWN_SIZE = 4
onready var game_vars = get_node("/root/GameVariables")
onready var DiceNum = $MarginContainer/VBoxContainer/DiceNum

func initialize():
    show()
    set_process(true)
    num = randi() % 7 + 1
    countdown = COUNTDOWN_SIZE
    $MarginContainer/VBoxContainer/Button.grab_focus()
    
func _process(_delta):
    countdown -= 1
    if countdown <= 0:
        countdown = COUNTDOWN_SIZE
        num += 1
        num = (num % 7)
        DiceNum.text = String(num)
    
func _input(event):
    if is_visible() and event is InputEventKey and ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [ControlsHandler.current_player]):
        get_parent().show_action_menu()
        hide()
    

func _on_Button_pressed():
    set_process(false)
    # TODO POLISH have a gradual slow down of the number
    # as a roulette effect
    emit_signal("completed", num)
    hide()
