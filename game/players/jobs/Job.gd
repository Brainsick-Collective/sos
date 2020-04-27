extends Resource

class_name Job

export var job_name : String
export var off_normal : Resource
export var off_special: Resource
export var off_effect : Resource
export var off_magic  : Resource

export var def_normal : Resource
export var def_special: Resource
export var def_effect : Resource
export var def_magic  : Resource

var move_dict = {}

func _ready():
    pass

func get_moves_dict():
  if move_dict.empty():
    move_dict["offense"] = { "normal" : off_normal, "special" : off_special, "magic" : off_magic, "effect" : off_effect }
    move_dict["defense"] = { "normal" : def_normal, "special" : def_special, "magic" : def_magic, "effect" : def_effect }
  return move_dict
