extends NinePatchRect

class_name ChoseEncounterPanel

var combatants
var spawner

signal enemy_chosen(pawn, combatant, spawner)
func _ready():
    pass

func initialize(player_pawn):
    for combatant in combatants:
        var button = Button.new()
        button.text = combatant.actor_name
        button.connect("pressed", self, "_on_button_pressed", [player_pawn, combatant])
        button.connect("focus_entered", self, "on_focused", [player_pawn, combatant])
        $Margins/Row/Column.add_child(button)
    
    $Margins/Row/Column2/Sprite.texture = combatants[0].get_sprite()
    $Margins/Row/Column2/CondensedPlayerPanel.set_condensed(combatants[0])
    $Margins/Row/Column.get_child(0).grab_focus()
        
func setup(_combatants, _spawner):
    combatants = _combatants
    spawner = _spawner

func _on_button_pressed(pawn, combatant):
    for c in combatants:
        if !spawner.on_hold_combatants.has(c) and c != combatant:
            spawner.on_hold_combatants.append(c)
    emit_signal("enemy_chosen", pawn, combatant, spawner)
    queue_free()
    
func _on_focused(combatant):
    $Margins/Row/Column2/Sprite.texture = combatant.get_sprite()
    $Margins/Row/Column2/CondensedPlayerPanel.set_condensed(combatant)
