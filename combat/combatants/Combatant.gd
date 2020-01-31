extends Position2D

class_name Combatant

enum move_types { empty = -1, normal, special, magic, effect }

var player
export var stats : Resource
export var moves = {}
export var job : Resource
var sprite
signal killed(player)
var mob = false
var battle = null
var combatant_name : String
onready var tween = $Tween

func initialize_n():
    var new_sprite = Sprite.new()
    new_sprite.texture = sprite
    new_sprite.scale = Vector2(0.322, 0.322)
    $Skin.add_child(new_sprite)
    sprite = new_sprite
    stats = stats.duplicate()
    stats.reset()
    combatant_name = player.name    
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
    combatant_name = player.name
    self.sprite = sprite
    set_moves_from_job()
    stats.connect("leveled_up", self, "_on_level_up")
    
func initialize_mob():
    self.sprite = $Skin/Sprite
    mob = true
    stats = stats.duplicate()
    stats.reset()
    stats.connect("health_depleted", self, "on_death")
    combatant_name = "mob" 
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

func on_death():
    if !player == MonsterFactory.GM:
        player.stats.health = 0
#        print("player health")
#        print(String(player.stats.health))
    emit_signal("killed", self)
