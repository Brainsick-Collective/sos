extends Popup

var boardplayer
var effect
onready var label = $NinePatchRect/MarginContainer/Label
var text
onready var click_through = false
onready var timer = $Timer

signal completed

func _ready():
    pass
func _process(delta): 
    #TODO: if click_through, add a subtle graphic effect
    pass
func init(player, newEffect, desc):
    _init()
    set_exclusive(true)
    boardplayer = player.board_character
    effect = newEffect
    text = desc
    connect("about_to_show", self, "_screen_entered")
    
func _input(event):
    if (event.is_pressed() and  event is InputEventKey 
        and ControlsHandler.is_current_player_action(event) and click_through):
    
        hide()
        
func just_text(desc):
    _init()
    text = desc

func _screen_entered():
    print("drawing notification")
    label.text = text
    #boardplayer.center_camera()
    #TODO: play effect
    timer.start()


func _on_timer_timeout():
    click_through = true
