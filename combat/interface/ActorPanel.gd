extends Control

var actor : Node

func _ready():
    pass

func set_actor(a):
    actor = a
    $PlayerStatus.set_combatant(a)
    $StatsRow.initialize(actor.stats)
