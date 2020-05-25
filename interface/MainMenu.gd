extends "res://interface/Menu.gd"

var game
var CharacterSelectMenu = preload("res://interface/menus/CharacterSelectMenu.tscn")
onready var SaveMenu = preload("res://interface/SaveSystem/SaveFileMenu.tscn")
onready var box = preload("res://addons/SyndiBox/SyndiBox.tscn")
onready var num_players = 1
const min_size = 1
const max_size = 4

func close():
    get_tree().quit()
    
    pass

func _ready():
    game = get_parent()
    SoundManager.play_bgm("server")
    
# warning-ignore:return_value_discarded
    $Column2/VBoxContainer/QuitButton.connect("pressed", self, "close")
# warning-ignore:return_value_discarded
    $Column2/VBoxContainer/NewGameButton.connect("pressed",self,"_menu_selected")
    $Column2/VBoxContainer/NewGameButton.grab_focus()
    $Column2/VBoxContainer/NewGameButton.grab_click_focus()

func _menu_selected():
    SoundManager.play_se("click")
    $Column2/VBoxContainer.hide()
    $bg/Console/AnimatedSprite.hide()
    $AnimationPlayer.play("TerminalZoom")
    yield($AnimationPlayer, "animation_finished")
    $Controllers/Controller1.show()
    
    $Controllers/Controller1.play("out")
    $Vents.play()
    $Column2.hide()
    var new_box = box.instance()
    new_box.DIALOG = "How many players?"
    new_box.AUTO_ADVANCE = false
    new_box.text_hide = false
    $bg/Console/MarginContainer.add_child(new_box)
    $Column/Row/ConfirmButton.grab_focus()
    $Column.show()

func _on_continue():
    SoundManager.play_se("click")
    var save_menu = SaveMenu.instance()
    hide()
    game.add_child(save_menu)
    save_menu.set_loading(true)

func _on_confirm_pressed():
    SoundManager.play_se("click")
    var menu = CharacterSelectMenu.instance()
    game.add_child(menu)
    menu.initialize(game, num_players)
    queue_free()

func _input(event):
    if $Column.is_visible():
        if event.is_action_pressed("ui_left"):
            _on_left_pressed()
        elif event.is_action_pressed("ui_right"):
            _on_right_pressed()

func _on_left_pressed():
    if num_players == min_size:
        return
    
    num_players = clamp(num_players-1, min_size, max_size)
    
    $Controllers.get_child(num_players).play("in")
    $Vents.play()
    
    
func _on_right_pressed():
    if num_players == max_size:
        return
    
    num_players = clamp(num_players+1, min_size, max_size)
    
    $Controllers.get_child(num_players-1).play("out")
    $Vents.play()
