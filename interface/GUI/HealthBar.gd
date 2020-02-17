extends TextureProgress

var combatant : Node
func _ready():
    pass

func set_combatant(c):
    combatant = c
    max_value = combatant.stats.max_health
    value = combatant.stats.health
    
func _process(delta):
    if combatant:
        max_value = combatant.stats.max_health
        value = combatant.stats.health
        $Label.text = String(combatant.stats.health) + "/" + String(combatant.stats.max_health)
