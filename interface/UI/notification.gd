extends Popup

class_name Notification

var effect
var text

onready var label = $NinePatchRect/MarginContainer/Label
onready var click_through = false
onready var timer = $Timer

func _process(_delta): 
    #TODO: if click_through, add a subtle graphic effect
    pass

func initialize(_target, newEffect, desc):
    set_exclusive(true)
    effect = newEffect
    text = desc
# warning-ignore:return_value_discarded
    connect("about_to_show", self, "_screen_entered")

func _input(event):
    # TODO this might cause bugs in PvP
    if (event.is_pressed() 
    and  event is InputEventKey 
    and ControlsHandler.is_current_player_action(event) 
    and click_through):
        queue_free()

func _screen_entered():
    label.text = text
    #TODO: play effect
    timer.start()


func _on_timer_timeout():
    click_through = true
