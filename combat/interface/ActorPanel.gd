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
    $column/row/name.text = a.actor_name
    $column/row/level.text = String(a.stats.level)
    $column/HealthBar.set_actor(a)
    $column/StatsRow.initialize(a.stats)
