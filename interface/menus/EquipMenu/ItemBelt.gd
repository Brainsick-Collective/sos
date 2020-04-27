extends VBoxContainer

var summary_panel
onready var ItemButton = preload("res://game/players/inventory/ItemButton.tscn")
signal item_chosen(item)

func initialize(items, summary):
    summary_panel = summary
    for item in items:
        var button = ItemButton.instance()
        add_child(button)
        button.initialize(item)
        button.connect("pressed", self, "item_chosen", [item], CONNECT_DEFERRED)        
        button.connect("focus_entered", summary_panel, "set_item", [item], CONNECT_DEFERRED)
        if item.equipped:
            button.disabled = true
        else:
            button.disabled = false
    if get_child_count() > 0:
        get_child(0).grab_focus()
        
        
func item_chosen(item):
    emit_signal("item_chosen", item)
