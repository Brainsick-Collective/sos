extends Panel

signal strings_finished
onready var sb = preload("res://addons/SyndiBox/SyndiBox.tscn")

func _ready():
    pass

func play_text(dialog : Dictionary):
    assert(dialog.has("dialog"))

#    var new_box = sb.instance()
#    if dialog.has("options"):
#        set_options(new_box, dialog["options"])
#    new_box.DIALOG = dialog["dialog"]
#    $MarginContainer.add_child(new_box)

func play_and_hold(text):
    var new_box = sb.instance()
    new_box.DIALOG = text
    new_box.connect("strings_finished", self, "_on_strings_finished")
    new_box.text_hide = false
    $MarginContainer.add_child(new_box)

func _on_strings_finished():
    emit_signal("strings_finished")

func play_dialog_box(box):
    box.connect("strings_finished", self, "_on_strings_finished")
    $MarginContainer.add_child(box)

