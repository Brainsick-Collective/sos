extends Popup

var boardplayer
var effect
onready var label = $NinePatchRect/MarginContainer/Label
var text
var click_through = false
onready var timer = $Timer

signal completed

func _ready():
    pass

func init(player, newEffect, desc):
    _init()
    boardplayer = player.board_character
    effect = newEffect
    text = desc
    connect("about_to_show", self, "_screen_entered")
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
