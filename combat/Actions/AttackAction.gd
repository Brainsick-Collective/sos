extends CombatAction

class_name AttackAction

func execute(target, reaction):
    assert(initialized)
    var hit = Hit.new()
    hit.damage = max(1, (actor.stats.strength * ATK_MOD))
    hit.target = target
    match reaction.type:
        move_types.special:
            pass
        move_types.magic:
            pass
        move_types.normal:
            hit.damage = max(1, hit.damage - (target.stats.defense * DEF_MOD))
        move_types.effect:
            hit = null
    
    #if chance of ability is met, then attach the buff or debuf animation
    return hit

