extends Position2D

class_name Combatant

enum move_types { empty = -1, normal, special, magic, effect }

var player
export(Resource) var stats
export var moves = {}
export(Resource) var job
var sprite
signal killed(player, reward)
var mob = false
var battle = null
var actor_name : String
onready var tween = $Tween

func initialize_n():
    var new_sprite = Sprite.new()
    new_sprite.texture = sprite
    new_sprite.scale = Vector2(0.322, 0.322)
    $Skin.add_child(new_sprite)
    sprite = new_sprite
    stats = stats.duplicate()
    stats.reset()
    actor_name = player.player_name   
    stats.connect("health_depleted", self, "on_death")
    stats.connect("leveled_up", self, "_on_level_up")
    
func flip_sprite():
    sprite.set_flip_h(!sprite.is_flipped_h())

func initialize(new_sprite, p):
    var sprite = Sprite.new()
    player = p
    stats = stats.duplicate()
    stats.player_id = player.id
    stats.reset()
    stats.connect("health_depleted", self, "on_death")
    sprite.texture = new_sprite.texture
    sprite.scale = Vector2(0.322, 0.322)
    $Skin.add_child(sprite)
    actor_name = player.player_name
    self.sprite = sprite
    set_moves_from_job()
    stats.connect("leveled_up", self, "_on_level_up")
    
func initialize_mob():
    self.sprite = $Skin/Sprite
    mob = true
    stats = stats.duplicate()
    stats.reset()
    stats.connect("health_depleted", self, "on_death")
    actor_name = name
    set_moves_from_job()
    
func set_moves_from_job():
    set_moves_from_dict(job.get_moves_dict())

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

func is_mob():
    return mob

func get_sprite():
    return sprite.get_texture()
    
func sync_stats():
    player.stats = stats
    
func on_death():
    var reward = null
    if !player == MonsterFactory.GM:
        player.stats.health = 0
    else:
        reward = $Rewards.give_rewards()
    emit_signal("killed", self, reward)
