extends VBoxContainer

var fighter1 : Node
var fighter2 : Node

func _ready():
    pass

func set_fighters(f1, f2):
    fighter1 = f1
    fighter2 = f2
    
func _process(_delta):
    if fighter1 and fighter2:
        $AttackStats/Row/F1.text = String(fighter1.stats.strength)
        $DefenseStats/Row/F1.text = String(fighter1.stats.defense)
        $SpeedStats/Row/F1.text = String(fighter1.stats.speed)
        $MagicStats/Row/F1.text = String(fighter1.stats.magic)
    
        $AttackStats/Row/F2.text = String(fighter2.stats.strength)
        $DefenseStats/Row/F2.text = String(fighter2.stats.defense)
        $SpeedStats/Row/F2.text = String(fighter2.stats.speed)
        $SpeedStats/Row/F2.text = String(fighter2.stats.magic)
