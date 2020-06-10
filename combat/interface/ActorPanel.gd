extends PanelContainer

var actor : Node

func _ready():
    pass

func set_actor(a):
    actor = a
    $PlayerStatus.set_combatant(a)
    $StatsRow.initialize(actor.stats)

func set_condensed(a):
    actor = a
    $margins/column/row/name.text = a.actor_name
    $margins/column/row/level.text = "Lv. " + String(a.stats.level)
    $margins/column/HealthBar.set_actor(a)
    $margins/column/StatsRow.initialize(a.stats)
