extends CombatAction

class_name OffensiveMagicAction

func execute(target, reaction):
    assert(initialized)
    var hit = Hit.new()
    hit.user = actor
    
    hit.damage = actor.stats.magic * move.modifier

    if reaction.type == move_types.magic:
        reaction.react(hit)

    hit.target = target
    determine_accuracy(hit)
    return hit
