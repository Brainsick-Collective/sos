extends Node

var effects = []

# TODO for all effects, play add an animation or notification to the queue, 
# to be played at the beggining of the player's turn or at the start of a new round
func execute_effects():
    for effect in effects:
        print("playing effect " + effect.name)
        effect.every_turn_effect()
        if effect.expiration > 0:
            effect.expiration -= 1
        else:
            effect.end_effect()
            effects.remove(effect)

func add_effect(effect):
    assert(effect is Effect)
    effects.append(effect)
    effect.initial_effect()

func remedy_effects(tags):
    for effect in effects:
        for tag in tags:
            if effect.tags.has(tag):
                effects.remove(effect)
