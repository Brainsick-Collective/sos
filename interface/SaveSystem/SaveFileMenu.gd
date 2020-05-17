extends Panel

onready var SaveOption = preload("res://interface/SaveSystem/SaveGameOption.tscn")
onready var Saves = $Margins/Row/Column

signal canceled
var loading : bool

func initialize(_player):
    pass

func _ready():
    var new_save_option : Button = SaveOption.instance()
    new_save_option.initialize(null)
    Saves.add_child(new_save_option)
    new_save_option.connect("focus_entered", $Margins/Row/SavePreviewPanel, "change_save", [null], CONNECT_DEFERRED)
    new_save_option.connect("pressed", self, "act_on_file", [null], CONNECT_DEFERRED)
    
    for file in GameSerializer.get_save_files():
        var new_option : Button = SaveOption.instance()
        new_option.initialize(file)
        Saves.add_child(new_option)
        new_option.connect("focus_entered", $Margins/Row/SavePreviewPanel, "change_save", [file], CONNECT_DEFERRED)
        new_option.connect("pressed", self, "act_on_file", [file], CONNECT_DEFERRED)
        
        
    if Saves.get_child_count() == 0:
        print("no saves to load")
        emit_signal("canceled")
        queue_free()
    else:
        Saves.get_child(0).grab_focus()
        
func set_loading(is_loading : bool):
    loading = is_loading

func act_on_file(res):
    if loading:
        GameSerializer.load_game(res)
    else:
        GameSerializer.save_game(res)
    queue_free()
