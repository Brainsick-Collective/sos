extends CombatMove

func _ready():
    pass

func react(hit):
    hit.damage = max(1, hit.damage / 2)
