extends Position2D

class_name Combatant

enum move_types { empty = -1, normal, special, magic, effect }

var player
export(Resource) var stats
export (String, MULTILINE) var description
export var moves = {}
export(Resource) var job
onready var sprite = $Skin/Sprite
signal killed(player, reward)
var mob = false
var battle = null
var actor_name : String
onready var skin = $Skin
onready var tween = $Tween
signal damage_given
signal attack_finished
    
func flip_sprite():
    sprite.set_flip_h(!sprite.is_flipped_h())

func initialize(p):
    sprite = $Skin/Sprite
    player = p
    stats = player.stats
    stats.player_id = player.id
    stats.connect("health_depleted", self, "on_death")
    actor_name = player.player_name
    set_moves_from_job()
    #stats.connect("leveled_up", self, "_on_level_up")

func set_target(target):
    $TargetAnchor.global_position = target.global_position

func set_moves_from_job():
    set_moves_from_dict(job.get_moves_dict())

func set_moves_from_dict(_moves : Dictionary):
    moves = _moves
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
    if hit.damage < stats.health:
        play("take damage")
    else:
        play("death") # change to death anim
    stats.take_damage(hit)

func is_mob():
    return mob

func get_sprite():
    return $Skin/Sprite.get_texture()

func play(string):
    if string == "attack":
        play_attack()
    else:
        $AnimationPlayer.play(string)
        yield($AnimationPlayer, "animation_finished")
    
func on_death():
    var reward = null
    if !player == GameVariables.GM:
        player.stats.health = 0
    else:
        reward = $Rewards.give_rewards()
    emit_signal("killed", self, reward)
    
func play_attack():
    var pos = $Skin.global_position
    $Tween.interpolate_property($Skin, "global_position", $Skin.global_position, $TargetAnchor.global_position, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
    $Tween.start()
    yield($Tween, "tween_completed")
    emit_signal("damage_given")
    $Tween.interpolate_property($Skin, "global_position", $TargetAnchor.global_position, pos, 0.75, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Tween.start()
    yield($Tween, "tween_completed")
    emit_signal("attack_finished")
    
