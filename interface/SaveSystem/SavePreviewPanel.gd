extends NinePatchRect

func change_save(save_game : SaveGame):
    if save_game:
        $Column/Label.text = save_game.resource_path
    else:
        $Column/Label.text = "a blank game file"
