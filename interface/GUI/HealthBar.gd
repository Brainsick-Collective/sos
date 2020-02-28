extends TextureProgress

var combatant : Node
func _ready():
    pass
func set_actor(a):
    set_combatant(a)
    
func set_combatant(c):
    combatant = c
    max_value = combatant.stats.max_health
    value = combatant.stats.health
    
func _process(_delta):
    if combatant:
        max_value = combatant.stats.max_health
        value = combatant.stats.health
        $HealthLabel.text = String(combatant.stats.health) + "/" + String(combatant.stats.max_health)
        if has_node("Level"):
            $Level.text = String(combatant.stats.level)
        if has_node("Name"):
            $Name.text = combatant.actor_name
