extends CombatAction

class_name EffectAction

func execute(target, _reaction):
    var hit = Hit.new()
    if !_reaction.tags.has("prevent_buff"):
        hit.effect = get_additional_effect(target)
    return hit
