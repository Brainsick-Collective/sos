extends Resource

class_name ActorPreview

export (Texture) var texture
export (String, MULTILINE) var description

func get_sprite():
    return texture
    
func get_description():
    return description
