extends Button

func _init(save : SaveGame):
    $MarginContainer/Row/Label.text = save.resource_path
