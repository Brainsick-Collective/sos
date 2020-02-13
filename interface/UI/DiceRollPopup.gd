extends Control

signal completed(turn_size)
var num = 0
var countdown = 0
const COUNTDOWN_SIZE = 4
onready var game_vars = get_node("/root/GameVariables")
onready var DiceNum = $NinePatchRect/MarginContainer/VBoxContainer/DiceNum

func initialize():
    _ready()
    show()
    num = randi() % 7 + 1
    roll_dice()
    countdown = COUNTDOWN_SIZE
    $NinePatchRect/MarginContainer/VBoxContainer/Button.grab_focus()
    
    
func roll_dice():
    set_process(true)
    set_process_input(true)
    
func _process(delta):
    countdown -= 1
    if countdown == 0:
        countdown = COUNTDOWN_SIZE
        num += 1
        num = (num % 7)
        DiceNum.text = String(num)
    

    

func _on_Button_pressed():
    set_process(false)
    # TODO POLISH have a gradual slow down of the number
    # as a roulette effect
    emit_signal("completed", num)
    hide()
