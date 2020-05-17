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

func new_parse(filename):
    var dialogs = []
    var file = File.new()
    file.open(filename, file.READ)
    var current = PoolStringArray([])
    var options = {}
    while not file.eof_reached():
        var line = file.get_line()
        if line.left(2) == "  ":
            if not options.keys().empty():
                dialogs.append({"dialog" : current.join("\n"), "options" : options.duplicate()})
            current = PoolStringArray([])
            options = {}
            options = get_options(line)
        else:
            current.append(line)
    
    dialogs.append({"dialog" : current.join("\n"), "options" : options.duplicate()})
    return dialogs

func get_options(line):
    return parse_json(line)

