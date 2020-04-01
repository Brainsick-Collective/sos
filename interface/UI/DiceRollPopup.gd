extends NinePatchRect

signal completed(turn_size)

var num = 0
var decay = 7
var decaying = false
var done = false

onready var game_vars = get_node("/root/GameVariables")
onready var DiceNum = $MarginContainer/VBoxContainer/DiceNum
onready var timer : Timer = $Timer

func initialize():
    show()
    timer.start()
    num = randi() % 7 + 1
    $MarginContainer/VBoxContainer/Button.grab_focus()

func _input(event):
    if is_visible() and event is InputEventKey and ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [ControlsHandler.current_player]):
        get_parent().show_action_menu()
        hide()
    

func _on_Button_pressed():
    decaying = true
    $MarginContainer/VBoxContainer/Button.hide()



func _on_Timer_timeout():
    if !visible:
        return
    if decaying and not done:
        if decay == 0:
            decaying = false
            done = true
            $DelayTimer.start()
            
        else:
            timer.wait_time += .03
            decay -= 1

    if decay >= 0 and not done:
        num += 1
        num = (num % 7)
        DiceNum.text = String(num)
        timer.start()


func _on_DiceRollPopup_visibility_changed():
    if visible:
        $MarginContainer/VBoxContainer/Button.show()
        

func _on_DelayTimer_timeout():
    done = false
    decay = 7
    timer.wait_time = .12
    emit_signal("completed", num)
    hide()
