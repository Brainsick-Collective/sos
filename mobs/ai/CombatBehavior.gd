extends Node

var moves : Array
var enemy

func _ready():
    pass

func get_defensive_move(matchups):
    var move_scores = {}
    for move in moves["defensive"]:
        if move.damage >0 and move.target != enemy:
            move_scores[move] = -1
