extends Control

var board
var current_player
onready var moves_label = $Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $ActorPanel1/Margins/VBoxContainer/Name
onready var health_bar = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress
onready var level_label = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/LVL
onready var health_label = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress/Label

onready var InventoryMenu = preload("res://interface/menus/InventoryMenu.tscn")

func initialize(new_board):
    board = new_board
    
func show_action_menu():
    $ActionMenu.show()
    $MapPreviewGUI.hide()
    focus_roll_button()
    
func change_player(player):
    current_player = player
    $ActorPanel.set_actor(player)
    $ActionMenu.show()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_focus()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_click_focus()
    $Counter.hide()
    
func focus_roll_button():
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_click_focus()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_focus()
        
func _on_RollButton_pressed():
    $DiceRollPopup.initialize()
# warning-ignore:return_value_discarded
    $DiceRollPopup.connect("completed", self, "show_moves")
    $ActionMenu.hide()

func _on_InventoryButton_pressed():
    var inventory_menu = InventoryMenu.instance()
    inventory_menu.set_inventory(current_player.get_inventory())
    add_child(inventory_menu)
    inventory_menu.initialize()
    $ActionMenu.hide()
    get_tree().paused = true
    yield(inventory_menu, "completed")
    get_tree().paused = false
    $ActionMenu.show()
    $ActionMenu/MarginContainer/VBoxContainer/InventoryButton.grab_focus()


func _on_ViewBoardButton_pressed():
    board.view_board()
    $ActionMenu.hide()


func _on_PlayerInfoButton_pressed():
    #show player stats and board character
    pass # Replace with function body.



func show_moves(_num):
    $Counter.show()
    
func set_preview_actor(actors):
    $MapPreviewGUI.show()
    $MapPreviewGUI.set_actor(actors[0])

func clear_preview():
    $MapPreviewGUI.clear_actor()
    $MapPreviewGUI.hide()

func _on_ActionMenu_visibility_changed():
    if $ActionMenu.is_visible():
        $Counter.hide()
    pass # Replace with function body.
