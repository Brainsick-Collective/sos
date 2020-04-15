extends Node

    
var save_resource : SaveGame
var file_hash = 0
export(String) var save_directory_path = "res://debug/save"
var save_file_format = "save_%03d.tres"
var resource_file_format = "save_%03d_%s.tres"
onready var Game = get_node("/root/Game")
var save_directory : Directory

signal game_loaded

func _ready():
    save_directory = Directory.new()
    
    if not save_directory.dir_exists(save_directory_path):
        save_directory.make_dir_recursive(save_directory_path)
    save_directory.open(save_directory_path)
        
func save_game(save : SaveGame ):
    if save != null:
        file_hash = save.save_hash
    else:
        file_hash = 0
        while(save_directory.file_exists(save_file_format % file_hash)):
            file_hash += 1
    
    save_resource = SaveGame.new()
    serialize_all_nodes()
    save_resource.save_hash = file_hash
    var save_path = save_directory_path.plus_file(save_file_format % file_hash)
    var error = ResourceSaver.save(save_path, save_resource)
    if error != OK:
      print("saving file resulted in error: " + String(error))
    
func load_game(save : SaveGame):
    get_tree().paused = true
    for i in range(4):
        ControlsHandler.clear_player_controls(i)
    
    for node in get_tree().get_nodes_in_group("unique_to_save_file"):
        node.queue_free()
    
    file_hash = save.save_hash
    var timer = Timer.new()
    add_child(timer)
    timer.start()
    timer.pause_mode = Node.PAUSE_MODE_PROCESS
    yield(timer, "timeout")
    timer.queue_free()
    load_node_states(save)
    
func load_node_states(save_resource):
    var keys = save_resource.data.keys()
    var duplicate_save = save_resource.data.duplicate()
    keys.sort()
    
    while(!keys.empty()):
        for node_path in keys:
            var node
            if has_node(node_path):
                node = get_node(node_path)
            var obj = dict2inst(save_resource.data[node_path])
            var parent = get_parent_from_path(node_path)
            if parent:
                if save_resource.data[node_path].has("filename"):
                    var new_node : Node = load(save_resource.data[node_path]["filename"]).instance()
                    if !node:
                        parent.add_child(new_node)
                        new_node.name = node_path.trim_prefix(parent.get_path())    
                        node = new_node
                elif !node:
                    parent.add_child(obj)
                    obj.name = node_path.trim_prefix(parent.get_path())
                
                for key in save_resource.data[node_path]:
                    if key == "filename":
                        continue
                    node.set(key, obj.get(key))

                duplicate_save.erase(node_path)        

        keys = duplicate_save.keys()
    # end while
    
    ready_all_nodes(self)
            
    for node_path in save_resource.data.keys():
        var node = get_node(node_path)
            
        for key in save_resource.data[node_path]:
            if key == "@subpath":
                continue
            if save_resource.data[node_path][key] is NodePath:
                if node:
                    var ref_node = get_node(save_resource.data[node_path][key])
                    if ref_node:
                        node.set(key, ref_node)
                    else:
                        print("Missing " + String(save_resource.data[node_path][key]) + " for " + key)
    
    for node in get_tree().get_nodes_in_group("save"):
        node.refresh_after_load()

    get_tree().paused = false
    emit_signal("game_loaded")

func ready_all_nodes(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            ready_all_nodes(N)
    if node.has_method("_ready"):
        node._ready()
    
func get_parent_from_path(node_path : String):
    var last_dash = node_path.find_last("/")
    var new_path = node_path.substr(0, last_dash)
    if !has_node(new_path):
        new_path # nonsense
    return get_node(new_path)

func serialize_all_nodes():
    for node in get_tree().get_nodes_in_group("save"):
        _serialize(node)

func get_descendants(node):
    var ret = []
    for child in node.get_children():
        ret.append(child)
        for node in get_descendants(child):
            ret.append(node)
    return ret
                
func _serialize(node : Node):
    if node.has_method("save_resources"):
        node.save_resources()
    
    var node_path = String(node.get_path())
    save_resource.data[node_path] = inst2dict(node)
    
    if node.get_filename():
        save_resource.data[node_path]["filename"] = node.get_filename()
    
    for key in save_resource.data[node_path]:
        if save_resource.data[node_path][key] is Node:
            save_resource.data[node_path][key] = save_resource.data[node_path][key].get_path()
    

func get_save_files():
    var saves = []
    save_directory.list_dir_begin()
    var file_name = save_directory.get_next()
    while (file_name != ""):
        if save_directory.current_is_dir():
            print("Found directory: " + file_name)
        else:
            saves.append(load(save_directory_path.plus_file(file_name)))
        file_name = save_directory.get_next()
    save_directory.list_dir_end()

    return saves

func save_resource(res, key, resource_name):
    var dir = Directory.new()
    var dir_string = save_directory_path.plus_file(resource_name)
    dir.make_dir(dir_string)
    
    var file_string = dir_string.plus_file(resource_file_format % [file_hash, key])
    ResourceSaver.save(file_string, res)
    
    return load(file_string)
