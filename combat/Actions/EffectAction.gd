extends CombatAction

class_name EffectAction

func execute(target, reaction):
	assert(initialized)
	actor.stats.strength = int(actor.stats.strength * 1.5)
	return null
