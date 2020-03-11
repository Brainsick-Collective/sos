extends Node

class_name CombatPhaseEffect

var combatant
var text
var transition
var label_handler : Node

func initialize(comb, txt, tran, handler):
    combatant = comb
    text = txt
    transition = tran
    label_handler = handler

func play_effect():
    assert(combatant)
    assert(text)
    assert(transition)
    label_handler.build_
