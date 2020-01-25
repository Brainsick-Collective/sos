extends Node
class_name CutsceneParser

func _ready():
    pass

func parse(filename):
    var dict = {}
    var file = File.new()
    file.open(filename, file.READ)
    var text = file.get_as_text()
    dict = parse_json(text)
    file.close()
    file.open(dict["dialogue"][0], file.READ)
    text = file.get_as_text()
    dict["dialogue"] = text
    return dict
