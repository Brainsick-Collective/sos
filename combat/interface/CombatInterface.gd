extends Control

#take in a player id, grab that control scheme,
#and listen to those input events

var moves1
var moves2 

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
	#moves1 = player1.get_moves()
	#moves2 = player2.get_moves()
	moves1 = default_moves
	moves2 = default_moves
	$TurnOrderPopup.show()
	$TurnOrderPopup.connect("chosen", self, "combat_start")
	
func combat_start(choice):
	if choice:
		$Label.text = "you start!"
		map_options($Options1, default_moves["offensive"])
		map_options($Options2, default_moves["defensive"])
		
	else:
		$Label.text = "opponent starts!"
		map_options($Options1, default_moves["defensive"])
		map_options($Options2, default_moves["offensive"])

func map_options(Option, moves):
	for child in Option.get_children():
		child.get_node("Label").text = moves[child.get_index()]