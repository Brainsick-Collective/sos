extends PanelContainer

var current

func _ready():
    current = $EquipmentMenu
    
func set_menu(index):
    current.hide()
    current.set_process_input(false)
    current = get_child(index)
    current.show()
    current.set_process_input(true)
