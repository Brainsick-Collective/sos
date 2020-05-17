extends ColorRect

signal completed

onready var menu_container = $MarginContainer/TabController/MenuContainer
func _ready():
    for child in $MarginContainer/TabController/MenuContainer.get_children():
        set_process_input(false)

func change_player(player):
    $MarginContainer/TabController/HeaderTabs/Current.grab_focus()
    for child in menu_container.get_children():
        child.initialize(player)
        
func open(menu : String):
    $MarginContainer/TabController.set_menu(menu)

func _unhandled_input(event):
    if visible:
        if ControlsHandler.is_action_pressed_by_current_player(event, "ui_cancel"):
            hide()
            get_tree().paused = false
            emit_signal("completed")
            

