extends PanelContainer

onready var actor_panel = $Column/ActorPanel
func _ready():
    clear_actor()

func set_actor(actor):
    actor_panel.show()
    actor_panel.set_process(true)
    $Column/Preview.texture = actor.get_sprite()
    
    if actor is Combatant:
        actor_panel.show()
        $Column/DescriptionPanel.hide()
        actor_panel.set_actor(actor)
    else:
        actor_panel.hide()
        $Column/DescriptionPanel.show()
        $Column/DescriptionPanel/Margins/Label.text = actor.get_description()
        

func clear_actor():
    actor_panel.set_process(false)
    actor_panel.hide()
