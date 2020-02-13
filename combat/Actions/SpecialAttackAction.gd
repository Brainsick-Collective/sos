extends CombatAction

class_name SpecialAttackAction

func execute(target, reaction):
    assert(initialized)
    var hit = Hit.new()
    if (reaction.type == move_types.normal or reaction.type == move_types.magic):
        hit.damage = (((actor.stats.strength + actor.stats.speed + actor.stats.magic) * 4.0) - (target.stats.defense + target.stats.speed + target.stats.magic)) * 1.6
        hit.target = target
    if (reaction.type == move_types.special):
        hit.damage = ((target.stats.strength + target.stats.speed + target.stats.magic) * 4.0) - (actor.stats.strength * 2.0) - (actor.stats.defense * 2.0)
        hit.target = actor
    if (reaction.type == move_types.effect):
        hit = null
    return hit
