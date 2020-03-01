extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var index
var VapeRider = preload("res://combat/combatants/VapeRider.tscn")
var EyeWitch = preload("res://combat/combatants/EyeWitch.tscn")
var FistBlade = preload("res://combat/combatants/FistBlade.tscn")
var starting_class_combatants = [VapeRider, EyeWitch, FistBlade]
var VapeRiderPawn = preload("res://board/pawns/VapeRiderPawn.tscn")
var FistBladePawn = preload("res://board/pawns/FistSwordPawn.tscn")
var EyeWizPawn = preload("res://board/pawns/EyeWizPawn.tscn")
var starting_class_pawns = [VapeRiderPawn, EyeWizPawn, FistBladePawn]
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
    
func get_pawn():
    var pawn = starting_class_pawns[index]
    return pawn.instance()

func get_class_by_index(ind):
    index = ind
    return get_combatant()

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
