extends Control

class_name Cutscene

onready var parser = CutsceneParser.new()
onready var dialogue = $Margin/DialogueBox
onready var portraits = $Actors
onready var sb = preload("res://addons/SyndiBox/SyndiBox.tscn")
onready var portrait_scene = preload("res://interface/UI/cutscene/Portrait.tscn")
var dialogs
export(String, FILE) var dialog_file



#TODO: create a portrait "theater" system that can work in parallel with the dialogue system
#portrait_text_map should look like {"portraits": [], "dialogue" []}
func load_dialogue(filename):
    if not parser:
        parser = CutsceneParser.new()
    dialogs = parser.new_parse(filename)

func play():
    if not dialogs:
        load_dialogue(dialog_file)

    dialogue.show()
    
    for dialog in dialogs:
        var box = build_dialog_box(dialog)
        dialogue.play_dialog_box(box)
        yield(dialogue, "strings_finished")
        
    queue_free()

func _on_DialogueBox_strings_finished():
    pass

func build_dialog_box(dialog):
    var box = sb.instance()
    box.text_hide = false
    var options = dialog["options"]
    for key in dialog["options"].keys():
        if key == "name":
            box.CHARACTER_NAME = options[key]
            if Kabuki.has_character(options[key]):
                box.prof_color = Kabuki.get_color(options[key])
        if key.match("*avi"):
            add_portrait(key.trim_suffix("_avi"), box.CHARACTER_NAME, options[key])
        if key == "map_move":
                move_on_map(options[key])
        if key == "remove":
            for n in options[key]:
                remove_portrait(n)
    box.DIALOG = dialog["dialog"]
    return box

func add_portrait(key, curr_name, expression = "default"):
    if expression == "":
        expression = "default"
    var destination = get_node("Actors/%sPortraits" % key.capitalize())
    var portrait = portrait_scene.instance()
    portrait.texture = Kabuki.get_portrait(curr_name, expression)
    for child in destination.get_children():
        if child.name == curr_name:
            child.texture = portrait.texture
            return
    destination.add_child(portrait, true)
    portrait.name = curr_name
    if key == "right":
        portrait.flip_h = true
    portrait.play("fadein_%s" % key)

func remove_portrait(n):
    for portrait in $Actors/LeftPortraits.get_children():
        if portrait.name == n:
            portrait.play("fadeout_left")

    for portrait in $Actors/RightPortraits.get_children():
        if portrait.name == n:
            portrait.play("fadeout_right")

func move_on_map(position):
    pass

func end_cutscene():
    for portrait in $Actors/LeftPortraits.get_children():
        portrait.play("fadeout_left")
    for portrait in $Actors/RightPortraits.get_children():
        portrait.play("fadeout_right")
