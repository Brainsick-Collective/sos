extends CombatAction

class_name AttackAction

func execute(target, reaction):
    assert(initialized)
    var hit = Hit.new()
    hit.user = actor
    hit.damage = max(1, (actor.stats.strength * ATK_MOD))
    hit.target = target
    match reaction.type:
        move_types.special:
            hit.effect = get_additional_effect(target)
        move_types.magic:
            if !reaction.tags.has("prevent_effects"):
                hit.effect = get_additional_effect(target)
        move_types.normal:
            hit.damage = max(1, hit.damage - (target.stats.defense * DEF_MOD))
            hit.effect = get_additional_effect(target)
        move_types.effect:
            hit = null
    determine_accuracy(hit)
    return hit

