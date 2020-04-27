extends Control

var player

onready var offensive_options = $Column/OffensiveActions
onready var defensive_options = $Column/DefensiveActions

func initialize(_player : Player):
    player = _player
    
    offensive_options.set_options(player.moves["offense"].values())
    defensive_options.set_options(player.moves["defense"].values())


func set_move(move : CombatMove):
    if move.phase == 0: # Offense
        offensive_options.set_option(move)
    else:
        defensive_options.set_option(move)

