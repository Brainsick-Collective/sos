extends Popup

var player_id
var old_stats
var new_stats
var unused_points = 0
var orig_points = 0
var stats

func initialize(old, new, points, stats_obj):
    old_stats = old
    new_stats = new
    stats = stats_obj
    unused_points = points
    orig_points = points

func _ready():
    for stat in $Panel/MarginContainer/VBoxContainer/OldStats.get_children():
        stat.text = String(old_stats[stat.name])
    
    if unused_points > 0:
        $Panel/MarginContainer/VBoxContainer/UnusedPoints.text = String(unused_points)
        $Panel/MarginContainer/VBoxContainer/UnusedPoints.show()
        for button in $Panel/MarginContainer/VBoxContainer/OldStats.get_children():
            button.focus_mode = FOCUS_ALL
            button.connect("pressed", self, "add_stat", [button.name])
        $Panel/MarginContainer/VBoxContainer/OldStats/strength.grab_focus()
    else:
        for button in $Panel/MarginContainer/VBoxContainer/OldStats.get_children():
            button.disabled = true
        $ConfirmPopup.show()
        $ConfirmPopup/margin/column/row/no.hide()
        yield($ConfirmPopup, "confirmed")
        
        queue_free()

func _process(delta):
    $Panel/MarginContainer/VBoxContainer/UnusedPoints.text = String(unused_points)
    
    for stat in $Panel/MarginContainer/VBoxContainer/NewStats.get_children():
        stat.text = String(new_stats[stat.name])
        var diff = $Panel/MarginContainer/VBoxContainer/Difference.get_node(stat.name)
        diff.text = String(new_stats[stat.name] - old_stats[stat.name])
        if new_stats[stat.name] > old_stats[stat.name]:
            stat.set("custom_colors/font_color_disabled", Color.green)
        else:
            stat.set("custom_colors/font_color_disabled", Color.white)

func set_stats(stats):
    old_stats = get_stats(stats)
    
func set_new_stats(stats):
    new_stats = get_stats(stats)
    
func get_stats(stats):
    return PoolStringArray([stats.max_health, 
        stats.max_mana, stats.speed, stats.strength, stats.defense, stats.magic])

func add_stat(stat):
    if unused_points > 0:
        unused_points -= 1
        if stat == "max_health":
            new_stats[stat] += 10
        else:
            new_stats[stat] += 1
        if unused_points == 0:
            confirm_points()
            
func confirm_points():
    for child in $Panel/MarginContainer/VBoxContainer/OldStats.get_children():
        child.focus_mode = FOCUS_NONE
    $ConfirmPopup.show()
    $ConfirmPopup/margin/column/row/yes.grab_focus()
    var answer = yield($ConfirmPopup, "confirmed")
    if answer:
        stats.from_dict(new_stats)
        queue_free()
    else:
        for button in $Panel/MarginContainer/VBoxContainer/OldStats.get_children():
            button.focus_mode = FOCUS_ALL
            new_stats = stats.as_mods()
            $ConfirmPopup.hide()
            unused_points = orig_points
            
