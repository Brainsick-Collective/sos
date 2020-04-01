extends CombatAction

class_name SpecialAttackAction

func execute(target, reaction):
    assert(initialized)
    var hit = Hit.new()
    hit.user = actor
    if (reaction.type == move_types.normal or reaction.type == move_types.magic):
        hit.damage = (((actor.stats.strength + actor.stats.speed) * 4.0) - (target.stats.defense + target.stats.speed)) * 1.6
        hit.target = target
    if (reaction.type == move_types.special):
        hit.damage = ((target.stats.strength + target.stats.speed) * 4.0) - (actor.stats.strength * 2.0) - (actor.stats.defense * 2.0)
        hit.target = actor
        hit.reverse = true
    if (reaction.type == move_types.effect):
        hit = null
    determine_accuracy(hit)
    return hit
