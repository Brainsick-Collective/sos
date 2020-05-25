extends Node

export (PackedScene) var combatant_1
export (PackedScene) var combatant_2
export (Resource) var stats

onready var combat_arena = preload("res://combat/CombatArena.tscn")
onready var player1 = $Player1

func _ready():
    var arena = combat_arena.instance()
    $Player1.combatant_scene = combatant_1
    $Player1.player_name = "test player"
    player1.control_scheme_keyword = "keyboard0"
    $Player1.id = 0
    stats.player_id = 0
    stats.reset()
    $Player1.stats = stats
    ControlsHandler.set_controls_by_keyword(player1.id,"keyboard0")
    ControlsHandler.give_player_ui_control(player1)
    var enemy = combatant_2.instance()
    var player = $Player1.get_combatant()
    if enemy is Mob:
        enemy.initialize_mob()
        enemy.stats.reset()
    
    arena.setup(player, enemy)
    add_child(arena)
    arena.initialize($Player1)

func play_transition():
    pass
