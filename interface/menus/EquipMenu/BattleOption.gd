extends VBoxContainer

var options = []
func _ready():
    options = []
    options.append($HBoxContainer/Normal)
    options.append($HBoxContainer/Special)
    options.append($Magic)
    options.append($Effect)
    
func set_options(options):
    for option in options:
        set_option(option)
    
    
func set_option(move : CombatMove):
    options[move.type].get_node("Label").text = move.name
