extends Combatant

class_name Mob

export (float) var spawn_rate
export (String) var off_priority
export (String) var def_priority
export (PackedScene) var defeated_trigger
export (float, 0,1) var money_drop_rate
export (int) var money_min = 0
export (int) var money_max = 0

    # TODO make this more complex somehow
    # maybe take into account what class and strengths the opponent has
    # OR: create a custom object that determines the survival rates of each move combo like in doka
    # and have different mobs have different strategies for survival / victory
    
func initialize_mob():
    mob = true
    stats = stats.duplicate()
    stats.reset()
    stats.connect("health_depleted", self, "on_death")
    actor_name = name
    player = GameVariables.GM
    set_moves_from_job()

func get_ai_move(turn):
    var options = moves[turn]
    if turn == "offense":
        return options[off_priority]
    else:
        return options[def_priority]

func get_cutscene_trigger():
    return defeated_trigger.instance()
    

    

