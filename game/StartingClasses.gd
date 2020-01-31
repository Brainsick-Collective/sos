extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var index
var vape_rider = preload("res://combat/combatants/VapeRider.tscn")
var eye_witch = preload("res://combat/combatants/EyeWitch.tscn")
var fist_blade = preload("res://combat/combatants/FistBlade.tscn")
var starting_class_combatants = [vape_rider, eye_witch, fist_blade]
var list_size = starting_class_combatants.size()
func initialize():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    index = 0
    
    pass
func get_first():
    index = 0
    return $Portraits.get_child(0);
    
func get_index():
    return index
    
func get_combatant() -> PackedScene:
    var combatant = starting_class_combatants[index]
    return combatant.instance()
    
func next_sprite():
    index = abs((index + 1) % list_size)
    return $Portraits.get_child(index).get_texture()
    
func last_sprite():
    index = (index + list_size - 1) % list_size
    return $Portraits.get_child(index).get_texture()
    
func get_board_piece():
    return $BoardPiece.get_child(index).get_texture()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
