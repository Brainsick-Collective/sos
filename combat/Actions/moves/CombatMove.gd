extends Resource

class_name CombatMove

enum move_types { empty = -1, normal, special, magic, effect }
enum phase_type { empty = -1, offense, defense }
var phase_lookup = {-1 : "empty", 0 : "offense", 1 : "defense"}
var type_lookup = { -1 : "empty", 0 : "normal", 1 : "special", 2 : "magic", 3 : "effect"}
export var name : String = "BaseMove"
export (move_types) var type = move_types.empty
export (phase_type) var phase = phase_type.empty
export var modifier : float
export var description : String = ""
export var icon : Texture = load("res://icon.png")
export var base_damage : int
export(float, 0.0, 1.0) var success_chance : float
export (String) var anim_name = "effect"
export (Resource) var effect
export(float, 0.0, 1.0) var effect_chance
export (Array) var tags

func react(_hit):
    print("didn't override")

func do_self_effect():
    pass

func do_enemy_effect(enemy):
    pass

func supplant_move_dict(dict : Dictionary):
    dict[phase_type.keys()[phase]][move_types.keys[type]] = self
