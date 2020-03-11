extends Node

class_name CombatPhaseHandler

signal phase_completed

var effects : Array
onready var label_handler = $"../UI/PopupLabelBuilder"

enum move_types { empty = -1, normal, special, magic, effect }

func do_phase(attacker : Combatant, defender : Combatant, attack_move : CombatAction, defend_move):
    var hit = attack_move.execute(defender, defend_move)
    attacker.connect("damage_given", hit, "execute",[] , CONNECT_ONESHOT)
    play_effect(attacker, attack_move.move)
    yield(attacker.get_node("AnimationPlayer"), "animation_finished")
    play_effect(defender, defend_move)
    yield(defender.get_node("AnimationPlayer"), "animation_finished")
    if hit.damage > 0:
        play_contact(attacker)
        yield(attacker, "attack_finished")
    if hit.buff:
        attacker.play(hit.buff)
    if hit.debuff:
        defender.play(hit.debuff)
    emit_signal("phase_completed")
    

func play_contact(attacker):
    attacker.play("attack")

func play_effect(combatant, move, anim : bool = true):
    if anim:
        combatant.play(move.anim_name) 
    label_handler.spawn_label(move.move_name, combatant, "effect")
