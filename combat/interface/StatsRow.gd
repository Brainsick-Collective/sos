extends HBoxContainer

var stats
func _ready():
    pass

func initialize(stats):
    self.stats = stats
    
func _process(delta):
    if stats:
        $ATK/Label.text = "ATK " + String(stats.strength)
        $DEF/Label.text = "DEF " + String(stats.defense)
        $SPD/Label.text = "SPD " + String(stats.speed)
        $MG/Label.text = "MG " + String(stats.magic)
