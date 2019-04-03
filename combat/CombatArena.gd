extends Node2D

func initialize(combatant1, combatant2):
	var sprite = Sprite.new()
	sprite.texture = combatant1.get_node("Pivot/Sprite").texture
	sprite.set_flip_h(true)
	$"1".add_child(sprite)
	sprite = Sprite.new()
	sprite.texture = combatant2.get_node("Pivot/Sprite").texture
	$"2".add_child(sprite)
	