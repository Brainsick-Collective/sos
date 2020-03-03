extends Combatant

class_name Mob

export (float) var spawn_rate
export (String) var off_priority
export (String) var def_priority
export (PackedScene) var defeated_trigger

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

func get_cutscene_trigger():
    return defeated_trigger.instance()
    

