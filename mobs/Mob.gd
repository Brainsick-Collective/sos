extends Combatant

class_name Mob

export var off_priority : String
export var def_priority : String

    # TODO make this more complex somehow
    # maybe take into account what class and strengths the opponent has
    # OR: create a custom object that determines the survival rates of each move combo like in doka
    # and have different mobs have different strategies for survival / victory
func get_ai_move(turn):
    var options = moves[turn]
    if turn == "offense":
        return options[off_priority]
    else:
        return options[def_priority]

func _ready():
    pass