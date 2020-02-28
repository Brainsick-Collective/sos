extends Item

export(int) var HEAL_AMOUNT = 20

func _apply_effect(user):
  user.stats.health = min(user.stats.health + HEAL_AMOUNT, user.stats.max_health)
  # TODO play heal animation?
