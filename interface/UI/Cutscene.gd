extends Control

class_name Cutscene

onready var parser = CutsceneParser.new()
onready var dialogue = $Margin/DialogueBox
onready var portrait = $CharacterPortrait
var sprite_text_map
export(String, FILE) var dialog_file

#TODO: create a sprite "theater" system that can work in parallel with the dialogue system
#sprite_text_map should look like {"sprites": [], "dialogue" []}
func load_dialogue(filename):
    if not parser:
        parser = CutsceneParser.new()
    sprite_text_map = parser.parse(filename)
    
func play():
    if not sprite_text_map:
        load_dialogue(dialog_file)
    portrait.texture = load(sprite_text_map["sprites"][0])
#    var sizeto=Vector2(70,100)
#    var size=sprite.texture.get_size()
#    var scalefactor=sizeto/size
#    sprite.scale = Vector2(0.322,0.322)
    dialogue.show()
    dialogue.sb.show()
    dialogue.play_text(sprite_text_map["dialogue"])

func _on_DialogueBox_string_finished():
    #TODO animate
    queue_free()
    pass # Replace with function body.
