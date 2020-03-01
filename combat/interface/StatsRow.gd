extends HBoxContainer

var stats
func _ready():
    pass

func initialize(_stats):
    stats = _stats
    
func _process(_delta):
    if stats:
        $ATK/CenterContainer/Label.text =   String(stats.strength)
        $DEF/CenterContainer/Label.text =   String(stats.defense)
        $SPD/CenterContainer/Label.text =   String(stats.speed)
        $MG/CenterContainer/Label.text  =   String(stats.magic)
