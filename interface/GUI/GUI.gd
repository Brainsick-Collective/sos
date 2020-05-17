extends Control

var board
var current_player

onready var moves_left_label = $Counter/MarginContainer/VBoxContainer/MovesLeft
onready var InventoryMenu = preload("res://interface/menus/InventoryMenu.tscn")
onready var SaveMenu = preload("res://interface/SaveSystem/SaveFileMenu.tscn")

func initialize(new_board):
    board = new_board
    $DiceRollPopup.connect("completed", self, "show_moves")
    
func show_action_menu():
    $ActionMenu.show()
    $MapPreviewGUI.hide()
    focus_roll_button()
    
func change_player(player):
    current_player = player
    $ActorPanel.set_actor(player)
    $ActionMenu.hide()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_focus()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_click_focus()
    $Counter.hide()
    $NextTurnPanel/Label.text = player.player_name + ", GO!"
    set_process_input(false)
 
    
func focus_roll_button():
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_click_focus()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_focus()
        
func _on_RollButton_pressed():
    $DiceRollPopup.initialize()
# warning-ignore:return_value_discarded
    $ActionMenu.hide()

func _on_InventoryButton_pressed():
    open_player_menu("Inventory")

func _on_ViewBoardButton_pressed():
    board.view_board()
    $ActionMenu.hide()

func _process(_delta):
    moves_left_label.text = String(current_player.board_character.get_moves())
    
func show_moves(_num):
    $Counter.show()
    
func set_preview_actor(actors):
    $MapPreviewGUI.show()
    $MapPreviewGUI.set_actor(actors[0])

func clear_preview():
    $MapPreviewGUI.clear_actor()
    $MapPreviewGUI.hide()
    
func on_move_confirm_choice(choice):
    if choice == true:
        $Counter.hide()

func _on_ActionMenu_visibility_changed():
    if $ActionMenu.is_visible():
        $Counter.hide()

func _on_InfoButton_pressed():
    open_player_menu("Player Info")

func _on_SystemButton_pressed():
    open_player_menu("System")

func open_player_menu(menu_string):
    var last_focus = get_focus_owner()
    $PlayerMenu.show()
    $PlayerMenu.change_player(current_player)
    $PlayerMenu.open(menu_string)
    get_tree().paused = true
    yield($PlayerMenu, "completed")
    last_focus.grab_focus()
    
