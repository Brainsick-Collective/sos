extends VBoxContainer

var fighter1 : Node
var fighter2 : Node

export(Color) var debuff_color
export(Color) var buff_color

func _ready():
    pass

func set_fighters(f1, f2):
    fighter1 = f1
    fighter2 = f2
    
func _process(_delta):
    if fighter1 and fighter2:
        for stat in ["strength", "defense", "magic", "speed"]:
            for fighter in [fighter1, fighter2]:
                var label = get_node(stat + "/Row/F" + fighter.get_parent().name)
                if fighter.stats.modifiers[stat] > 0:
                    label.add_color_override("font_color", buff_color)
                elif fighter1.stats.modifiers[stat] < 0:
                    label.add_color_override("font_color", debuff_color)
                else:
                    label.add_color_override("font_color", Color(1,1,1,1))

        $strength/Row/F1.text = String(fighter1.stats.strength)
        $defense/Row/F1.text = String(fighter1.stats.defense)
        $speed/Row/F1.text = String(fighter1.stats.speed)
        $magic/Row/F1.text = String(fighter1.stats.magic)
    
        $strength/Row/F2.text = String(fighter2.stats.strength)
        $defense/Row/F2.text = String(fighter2.stats.defense)
        $speed/Row/F2.text = String(fighter2.stats.speed)
        $magic/Row/F2.text = String(fighter2.stats.magic)
