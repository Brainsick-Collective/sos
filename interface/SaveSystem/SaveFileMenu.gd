extends NinePatchRect

onready var SaveOption = preload("res://interface/SaveSystem/SaveGameOption.tscn")
onready var Saves = $Margins/Row/Column

signal canceled

func _ready():
    for file in GameSerializer.get_save_files():
        var new_option : Button = SaveOption.instance()
        Saves.add_child(new_option)
        new_option.connect("focus_entered", $Margins/Row/SavePreviewPanel, "change_save", [file], CONNECT_DEFERRED)
        new_option.connect("pressed", self, "load_save", [file], CONNECT_DEFERRED)
        
    if Saves.get_child_count() == 0:
        print("no saves to load")
        emit_signal("canceled")
        queue_free()
    else:
        Saves.get_child(0).grab_focus()
        

func load_save(res):
    GameSerializer.load_game(res)
    queue_free()
