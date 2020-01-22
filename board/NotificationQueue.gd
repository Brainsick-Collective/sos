extends Node

export var ui_parent_path : NodePath
onready var queue = []
onready var ui_parent = get_node(ui_parent_path)
onready var Notification = preload("res://interface/UI/notification.tscn")
signal emptied

func add_from_vals(player, effect, desc) -> void:
    var notif = Notification.instance()
    notif.init(player,effect,desc)
    queue.append(notif)

func add_notif_to_q(note) -> void:
    queue.append(note)
    
func is_empty():
    return queue.empty()
    
func play_queue() -> void:
    for note in queue:
        ui_parent.add_child(note)
        note.popup()
        print("popup'd'")
        yield(note, "popup_hide")
        note.queue_free()
    queue.clear()
    print("queue cleared")
    emit_signal("emptied")
    
func has_notes() -> bool:
    return !queue.empty()
