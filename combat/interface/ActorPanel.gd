extends Control

var actor : Node

func _ready():
    pass

func set_actor(a):
    actor = a
    $PlayerStatus.set_combatant(a)
    $StatsRow.initialize(actor.stats)

func set_condensed(a):
    actor = a
    $VBoxContainer/HealthBar.set_actor(a)
    $VBoxContainer/StatsRow.initialize(a.stats)
