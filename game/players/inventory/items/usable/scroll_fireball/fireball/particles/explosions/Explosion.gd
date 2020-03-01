extends Particles2D

func _ready():
    one_shot = true
    $SmallSparkles.one_shot = true
# warning-ignore:return_value_discarded
    get_tree().create_timer(lifetime * 2.0).connect('timeout', self, 'queue_free')
