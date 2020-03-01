extends PanelContainer

onready var actor_panel = $Column/ActorPanel
func _ready():
    clear_actor()

func set_actor(actor):
    actor_panel.show()
    actor_panel.set_process(true)
    $Column/Preview.texture = actor.get_sprite()
    actor_panel.set_actor(actor)

func clear_actor():
    actor_panel.set_process(false)
    actor_panel.hide()
