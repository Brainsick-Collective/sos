extends Position2D

func initialize(new_sprite):
	var sprite = Sprite.new()
	sprite.texture = new_sprite.texture
	add_child(sprite)