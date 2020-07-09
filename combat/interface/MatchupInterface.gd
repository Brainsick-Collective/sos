extends CanvasLayer

var fighter1
var fighter2
enum move_types { empty = -1, normal, special, magic, effect }
onready var MatchupOption = preload("res://combat/interface/MatchupOption.tscn")
var matchup_visible = false
var matchups

func initialize(f1, f2):
    fighter1 = f1
    fighter2 = f2
    
func set_predictions(attacker):
    for child in $PredictionsPanel/Margin/Column.get_children():
        if child is PanelContainer:
            child.queue_free()
    var defender = null
    if attacker == fighter1:
        defender = fighter2
    else:
        defender = fighter1
    for attack in attacker.get_node("OffenseMoves").get_children():
        if attack.type == move_types.effect:
            continue
        for defense in defender.moves["defense"].values():
            if !defense or defense.type == move_types.effect:
                continue
            var option = MatchupOption.instance()
            option.initialize(attacker, attack, defender, defense)
            $PredictionsPanel/Margin/Column.add_child(option)
    
func get_matchups():
    return matchups


func _unhandled_input(event):
    if $PredictionsPanel/Margin/Column.get_child_count() == 1:
        return
    if event and ControlsHandler.is_action_pressed_by_players(event, "ui_cancel", [fighter1.player, fighter2.player]):
        if matchup_visible:
            $PredictionsPanel/AnimationPlayer.play("Hide Matchup")
            matchup_visible = false
            get_tree().paused = false
        else:
            $PredictionsPanel/AnimationPlayer.play("Show Matchup")
            matchup_visible = true
            get_tree().paused = true
