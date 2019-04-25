extends CombatAction

class_name OffensiveMagicAction

func execute(target, reaction):
	assert(initialized)
	var hit = Hit.new()
	hit.damage = actor.stats.magic * move.modifier
	hit.target = target
	return hit
