extends Node

class_name CombatAction

var initialized = false


# Since Actions can be instanced by code (ie skills) these
# actions doesn't have an owner, that's why we get the owner
# from it's parent (BattlerActions.gd)
enum move_types { empty = -1, normal, special, magic, effect }
onready var actor = get_parent().get_owner()
export var move : Resource
var type
#export(Texture) var icon = load("res://assets/sprites/icons/slash.png")
export(String) var description : String = "Base combat action"



func initialize(battler) -> void:
	move = move.duplicate()
	type = move.type
	actor = battler
	initialized = true

func execute(target, reaction):
	assert(initialized)
	print("%s missing overwrite of the execute method" % name)
	return false

func return_to_start_position():
	yield(actor.skin.return_to_start(), "completed")

func can_use() -> bool:
	return true

func get_type():
	return move.type

func get_name():
	return move.move_name