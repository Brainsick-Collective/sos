extends GridContainer

func initialize():
    update_focus_neighbours()
    for button in get_children():
        button.connect("tree_exiting", self, "_on_ItemButton_tree_exited", [button])
    if get_children():
        get_child(0).grab_focus()

func _on_ItemButton_tree_exited(button):
    var to_focus_path = button.focus_neighbour_left if button.get_index() > 0 else button.focus_neighbour_right
    button.get_node(to_focus_path).grab_focus()
    update_focus_neighbours(button)

func update_focus_neighbours(ignore=null):
    var buttons_to_update = get_children()
    # There's a bug with the Node.tree_exited signal so the button is still in the tree
    if ignore:
        buttons_to_update.remove(ignore.get_index())
    var count = buttons_to_update.size()
    var index = 0
    for button in buttons_to_update:
        var index_previous = index - 1
        var index_next = (index + 1) % count
        button.focus_neighbour_left = button.get_path_to(buttons_to_update[index_previous])
        button.focus_neighbour_right = button.get_path_to(buttons_to_update[index_next])
        index += 1

func clear():
    for child in get_children():
        child.queue_free()
