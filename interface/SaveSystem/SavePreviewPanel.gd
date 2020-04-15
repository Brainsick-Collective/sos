extends NinePatchRect

func change_save(save_game : SaveGame):
    $Column/Label.text = save_game.resource_path
