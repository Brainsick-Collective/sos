extends CombatAction

class_name EffectAction

func execute(target, reaction):
	assert(initialized)
	actor.stats.strength *= int(1.2)
	return null
