extends Control

onready var player = $Player
onready var level_note = preload("res://interface/UI/LevelUpNote.tscn")

func _ready():
    player.stats = load("res://game/players/stats/chika.tres")
    player.stats.reset()
    player.combatant_scene = load("res://combat/combatants/VapeRider.tscn")
    player.actor_name = "test player"
    $CondensedPlayerPanel.set_condensed(player)
    player.stats.connect("leveled_up", self, "level_up_note", [player.stats])
    
func level_up():
    player.stats.xp += 1000

func level_up_note(old, new, points, stats):
    var note = level_note.instance()
    add_child(note)
    note.initialize(old, new, points, stats)
    note.popup()
