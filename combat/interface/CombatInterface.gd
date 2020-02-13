extends Control

#take in a player id, grab that control scheme,
#and listen to those input events

var moves1
var moves2 
var fighter1
var fighter2
var isFighterOneFirst

onready var default_moves = {
    "offensive" :
        ["of. magic",
        "ability",
        "strike",
        "attack"],
    "defensive" :
        ["d. magic",
        "give up",
        "parry",
        "defend"]
}

enum move_types { empty = -1, normal, special, magic, effect }
onready var move_map = {
    "ui_up"    : 0,
    "ui_down"  : 1,
    "ui_right" : 2,
    "ui_left"  : 3
    }

# will be of the form {"offensive": [magic, ability, strike, attack], "defensive" : [magic, ability, strike, attack]}
# each of the 4 options is of type Action, and the action itself will have a function for activating it based on the other player's stats

func initialize(player1, player2):
    _ready()
    fighter1 = player1
    fighter2 = player2
    
func decide_turns():
    if not get_tree():
        yield(self, "tree_entered")
    $Label.text = ""
    $Label.hide()
    $Options1.hide()
    $Options2.hide()
    $TurnOrderPopup.reset()
    $TurnOrderPopup.decide_turns(fighter1.stats.speed, fighter2.stats.speed)
    get_tree().paused = true
    isFighterOneFirst = yield($TurnOrderPopup, "chosen")
    get_tree().paused = false
    do_combat_phase(isFighterOneFirst)
    
func do_combat_phase(choice):
    if choice:
        $Label.text = "your Turn!"
        map_options($Options1, fighter1.moves["offense"])
        map_options($Options2, fighter2.moves["defense"])
    else:
        $Label.text = "opponents Turn!"
        map_options($Options2, fighter2.moves["offense"])
        map_options($Options1, fighter1.moves["defense"])
func map_options(Option, moves):
    for move in moves:
        Option.get_child(moves[move].type).get_node("Label").text = moves[move].move_name

func _process(delta):
    $Stats/Row/Fighter1Stats/Attack/Label.text = String(fighter1.stats.strength)
    $Stats/Row/Fighter1Stats/Defense/Label.text = String(fighter1.stats.defense)
    $Stats/Row/Fighter1Stats/Speed/Label.text = String(fighter1.stats.speed)
    $Stats/Row/Fighter1Stats/Magic/Label.text = String(fighter1.stats.magic)

    $Stats/Row/Fighter2Stats/Attack/Label.text = String(fighter2.stats.strength)
    $Stats/Row/Fighter2Stats/Defense/Label.text = String(fighter2.stats.defense)
    $Stats/Row/Fighter2Stats/Speed/Label.text = String(fighter2.stats.speed)
    $Stats/Row/Fighter2Stats/Magic/Label.text = String(fighter2.stats.magic)
    
func _on_TurnOrderPopup_chosen(choice):
    $Options1.show()
    $Options2.show()
    pass # Replace with function body.
