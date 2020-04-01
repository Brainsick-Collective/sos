extends Node

class_name CombatPhaseHandler

signal phase_completed

var effects : Array
onready var label_handler = $"../UI/PopupLabelBuilder"
onready var timer : Timer = $"Timer"

enum move_types { empty = -1, normal, special, magic, effect }

func do_phase(attacker : Combatant, defender : Combatant, attack_move : CombatAction, defend_move):
    var hit = attack_move.execute(defender, defend_move)
    
    # show attacker's move
    attacker.connect("damage_given", self, "connect_hit", [hit] , CONNECT_ONESHOT)
    play_effect(attacker, attack_move.move)
    yield(timer, "timeout")
    
    # if its an ability, play the ability buff
    if attack_move.move.type == move_types.effect:
        hit.effect.apply()
        play_effect(hit.effect.target, hit.effect)
        yield(timer, "timeout")
    
    # show defender's move
    play_effect(defender, defend_move)
    yield(timer, "timeout")
    
    # if contact is made, play contact anim
    if hit.damage > 0:
        play_contact(attacker)
        yield(timer, "timeout")
        
    
    # if hit has an added effect, play here
    if hit.effect and attack_move.move.type != move_types.effect:
        hit.effect.apply()
        play_effect(hit.effect.target, hit.effect)
    emit_signal("phase_completed")
    

func connect_hit(hit):
    var miss = CombatMove.new()
    miss.name = "miss!"
    if hit.miss:
        play_effect(hit.target, miss, false)
    else:
        hit.execute()

func play_contact(attacker):
    attacker.play("attack")

#move can be a Move or an Effect
func play_effect(combatant, move, anim : bool = true):
    timer.start()
    label_handler.spawn_label(move.name, combatant, "effect")
    if anim:
        combatant.play(move.anim_name) 

    
