extends CombatAction

class_name EffectAction

func execute(_target, _reaction):
    assert(initialized)
    actor.stats.strength = int(actor.stats.strength * 1.5)
    return null
