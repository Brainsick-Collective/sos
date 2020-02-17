extends Popup

class_name Notification

var effect
var text

onready var label = $NinePatchRect/MarginContainer/Label
onready var click_through = false
onready var timer = $Timer

signal completed

func _ready():
    pass
func _process(delta): 
    #TODO: if click_through, add a subtle graphic effect
    pass
func initialize(target, newEffect, desc):
    _init()
    set_exclusive(true)
    effect = newEffect
    text = desc
    connect("about_to_show", self, "_screen_entered")
    
func _input(event):
    if (event.is_pressed() 
    and  event is InputEventKey 
    and ControlsHandler.is_current_player_action(event) 
    and click_through):
        hide()

func _screen_entered():
    label.text = text
    #TODO: play effect
    timer.start()


func _on_timer_timeout():
    click_through = true
