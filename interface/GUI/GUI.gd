extends Control

var board
var current_player
onready var moves_label = $Counter/MarginContainer/VBoxContainer/MovesLeft
onready var name_label = $ActorPanel1/Margins/VBoxContainer/Name
onready var health_bar = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress
onready var level_label = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/LVL
onready var health_label = $ActorPanel1/Margins/VBoxContainer/HBoxContainer/TextureProgress/Label

onready var InventoryMenu = preload("res://interface/menus/InventoryMenu.tscn")

func _ready():
    pass

func initialize(board):
    self.board = board
    
func change_player(player):
    current_player = player
    $ActionMenu.show()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_focus()
    $ActionMenu/MarginContainer/VBoxContainer/RollButton.grab_click_focus()
    
    
func _process(delta):
    if(current_player):
        moves_label.text = String(current_player.board_character.get_moves())
        name_label.text =String(current_player.board_character.get_name())
        level_label.text = String(current_player.stats.level)
        health_bar.max_value = current_player.stats.max_health
        health_bar.value = current_player.stats.health
        health_label.text = String(current_player.stats.health)
func _on_RollButton_pressed():
    $DiceRollPopup.initialize()
    $ActionMenu.hide()
    #board roll
    pass # Replace with function body.

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
    #board view mode activate
    pass # Replace with function body.


func _on_PlayerInfoButton_pressed():
    #show player stats and board character
    pass # Replace with function body.
