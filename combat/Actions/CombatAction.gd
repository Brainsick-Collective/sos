extends Node

class_name CombatAction

var initialized = false

const DEF_MOD = 1.2
const ATK_MOD = 2.8
const MAG_MOD = 2.8
const STK_MOD = 4.0 


enum move_types { empty = -1, normal, special, magic, effect }
onready var actor
export(Resource) var move
var type
#export(Texture) var icon ???
export(String) var description : String = "Base combat action"



func initialize(battler) -> void:
    move = move.duplicate()
    type = move.type
    actor = battler
    initialized = true

func execute(_target, _reaction):
    assert(initialized)
    print("%s missing overwrite of the execute method" % name)
    return false

func get_additional_effect(target):
    var chance = randf()
    if chance <= move.effect_chance:
        var effect = move.effect.duplicate()
        effect.set_target(actor, target)
        return effect
        # TODO: play animation or add/or notif to queue
    else:
        return null

# TODO: maybe change this so that higher speed helps you land hard to hit moves?
func determine_accuracy(hit):
    randomize()
    var hit_chance = randf()
    var dodge_chance = randf()
    if (dodge_chance < determine_dodge(hit.user.stats.speed, hit.target.stats.speed)
        or hit_chance > move.success_chance):
            hit.miss = true

func determine_dodge(sp_a, sp_d):
    var diff = clamp(((sp_d - sp_a) / sp_a), -1, 5.7)
    var chance = (diff + 1) / 6
    print("dodge chance is " + String(chance)) 
    return chance
 
func return_to_start_position():
    yield(actor.skin.return_to_start(), "completed")

func can_use() -> bool:
    return true

func get_type():
    return move.type

func get_name():
    return move.name
