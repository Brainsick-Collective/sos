extends Popup

var player_id
var old_stats
var new_stats

func _ready():
    pass

func initialize(id):
    player_id = id
    
func _input(event):
    if ControlsHandler.which_player(event) == player_id:
        queue_free()

func set_old_stats(stats):
    old_stats = get_stats(stats)
    
func set_new_stats(stats):
    new_stats = get_stats(stats)
    
func get_stats(stats):
    return PoolStringArray([stats.max_health, 
        stats.max_mana, stats.speed, stats.strength, stats.defense, stats.magic])

func play_text():
    var text = old_stats.join(" ") + "\n" + new_stats.join(" ")
    $Panel/MarginContainer/VBoxContainer/stats.text = text
    
