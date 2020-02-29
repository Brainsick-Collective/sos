extends HBoxContainer

var stats
func _ready():
    pass

func initialize(stats):
    self.stats = stats
    
func _process(_delta):
    if stats:
        $ATK/Label.text =   String(stats.strength)
        $DEF/Label.text =   String(stats.defense)
        $SPD/Label.text =   String(stats.speed)
        $MG/Label.text  =   String(stats.magic)
