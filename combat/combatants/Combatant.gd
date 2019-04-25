extends Position2D

class_name Combatant

enum move_types { empty = -1, normal, special, magic, effect }

var player
var stats : Stats
var moves = {}
signal killed


func initialize(new_sprite, p):
	var sprite = Sprite.new()
	player = p
	stats = player.stats.duplicate()
	stats.reset()
	stats.connect("health_depleted", self, "on_death")
	sprite.texture = new_sprite.texture
	$Skin.add_child(sprite)
	
	
func set_moves_from_dict(moves : Dictionary):
	self.moves = moves
	var attack = AttackAction.new()
	attack.move = moves["offense"]["normal"]
	$OffenseMoves.add_child(attack)
	attack.initialize(self)
	var special = SpecialAttackAction.new()
	special.move = moves["offense"]["special"]
	$OffenseMoves.add_child(special)
	special.initialize(self)
	var magic = OffensiveMagicAction.new()
	magic.move = moves["offense"]["magic"]
	$OffenseMoves.add_child(magic)
	magic.initialize(self)
	var effect = EffectAction.new()
	effect.move = moves["offense"]["effect"]
	$OffenseMoves.add_child(effect)
	effect.initialize(self)

func get_move(move_type, isOffense):
	if isOffense:
		for move in $OffenseMoves.get_children():
			if move.move.type == move_type:
				return move
	else:
		for type in moves["defense"]:
			if moves["defense"][type].type == move_type:
				return moves["defense"][type]
				
func get_stats_string():
	var string = "Health: " + String(stats.health) + "\n" + "Magic: " + String(stats.magic) + "\n" + "Strength: " + String(stats.strength) + "\n" + "Speed: " + String(stats.speed) + "\n" + "Defense: " + String(stats.defense)
	return string
func get_id():
	return player.get_id()

func take_damage(hit):
	stats.take_damage(hit)

func on_death():
	player.stats.health = 0
	emit_signal("killed", player)