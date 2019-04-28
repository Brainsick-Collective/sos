extends CombatAction

class_name AttackAction

func execute(target, reaction):
	assert(initialized)
	var hit = Hit.new()
	hit.damage = (actor.stats.strength * 2.8) - (target.stats.defense * 1.2)
	hit.target = target
	if (reaction.type == move_types.special):
		hit.damage *= 1.6
	if (reaction.type == move_types.magic):
		hit.damage *= 1.4
		hit.damage *= reaction.modifier
	if (reaction.type == move_types.effect):
		hit = null
	return hit
