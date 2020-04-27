extends Button

func initialize(save : SaveGame):
    if save:
        $MarginContainer/Row/Label.text = save.resource_path
    else:
        $MarginContainer/Row/Label.text = "new game"
