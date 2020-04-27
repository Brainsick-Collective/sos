extends Area2D

class_name TileArea
# This is a class that can be interacted with by other board actors
# It returns a preview or scene information from it's parent, 
# as set by an initializer (dynamic) OR export var (static)


export (PackedScene) var preview_scene
var preview

func _ready():
    if preview_scene:
        preview = preview_scene.instance()
        preview.initialize(get_parent())
    else:
        preview = get_parent().build_preview()


func get_preview():
    if preview:
        return preview
    else:
        print("no preview found for :" + get_parent().name)
