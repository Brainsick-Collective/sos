extends NinePatchRect

var actor : Node

func _ready():
    pass

func set_actor(a):
    actor = a
    $Margins/VBoxContainer/HealthRow/HealthBar.set_combatant(a)
    $Margins/VBoxContainer/Name.text = actor.actor_name
    $Margins/VBoxContainer/HealthRow/LVL.text = "LVL " + String(actor.stats.level)
    $Margins/VBoxContainer/StatsRow.initialize(actor.stats)
