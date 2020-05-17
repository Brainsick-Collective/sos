extends VBoxContainer

var tabs = { "Equipment" : 0, "System" : 1, "Inventory" : 2, "Player Info" : 3 }
var tab_names_lookup = ["Equipment", "System", "Inventory", "Player Info"]

onready var current = $HeaderTabs/Current
onready var left = $HeaderTabs/Left
onready var right = $HeaderTabs/Right

var current_menu
var current_menu_index

func set_menu(menu_string : String):
    var menu_index = tabs[menu_string]
    $MenuContainer.set_menu(menu_index)
    set_button_names(menu_index)
    current_menu = menu_string
    current_menu_index = menu_index
    
func set_button_names(menu_index):
    current.text = tab_names_lookup[menu_index]
    left.text = tab_names_lookup[get_left_option(menu_index)]
    right.text = tab_names_lookup[get_right_option(menu_index)]

func set_menu_from_index(index):
    set_menu(tab_names_lookup[index])

func get_left_option(index):
    return (index - 1) % tab_names_lookup.size()
    
func get_right_option(index):
    return (index + 1) % tab_names_lookup.size()

func _on_Left_pressed():
    set_menu_from_index(get_left_option(current_menu_index))

func _on_Right_pressed():
    set_menu_from_index(get_right_option(current_menu_index))
