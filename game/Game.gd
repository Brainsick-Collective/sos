extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
onready var CombatArena = preload("res://combat/CombatArena.tscn")
onready var Cutscene = preload("res://interface/UI/Cutscene.tscn")
var board
var queue = null
var cutscene = null

func _ready():
    var main_menu = MainMenu.instance()
    add_child(main_menu)
    main_menu.initialize(self)
    
    
func load_cutscene(cutscene_file):
    var new_cutscene = Cutscene.instance()
    new_cutscene.load_dialogue(cutscene_file)
    return play_cutscene(new_cutscene)

func play_cutscene(new_cutscene):
    new_cutscene.connect("tree_exited", self, "_after_cutscene", [new_cutscene])
    $UI.add_child(new_cutscene)
    new_cutscene.play()
    get_tree().paused = true
    return new_cutscene
    
func _after_cutscene(curr_cutscene):
    curr_cutscene.queue_free()
    get_tree().paused = false
    pass
    
func initialize_game(new_board):
    board = new_board
    queue = $NotificationQueue
    board.connect("tree_entered", queue, "change_ui_node", [board.get_node("UI")])
    queue.ui_parent = board.get_node("UI")
    set_controls()
    queue.connect("emptied", self, "on_queue_finished")
    board.connect("turn_finished", self, "_on_move_finished")
    
func set_controls():
    ControlsHandler.initialize($Players)
    for player in $Players.get_children():
        player.board_character.player_id = player.get_id()
        player.controls = ControlsHandler.get_controls(player.get_id())
        player.board_character.controls = ControlsHandler.get_controls(player.get_id())
    
func enter_space_scene(player_pawn):
    # this whole thing is kinda fucked, could use an overhaul
    var scene = player_pawn.player.battle
    var new = false
    
    if !scene:
        new = true
        scene = $Board/GameBoard.get_space_scene(player_pawn)
    else:
        scene.switch_fighters(player_pawn.player.combatant)
        
    if scene:
        remove_child(board)
        add_child(scene)
        if new:
            add_child(scene)
            if scene is Control:
                scene.initialize(player_pawn.player)
            else:
                scene.initialize()
            scene.connect("completed", self, "add_note_to_q")
        yield(scene, "completed")
        if scene:
            remove_child(scene)
        
        add_child(board)
    if cutscene:
        play_cutscene(cutscene)
    #TODO: the note q should be at game level?
    print("ended scene, or no scene available")
    queue.play_queue()

func on_queue_finished():
    set_process(true)
    board.next_turn()
    
func queue_cutscene(new_cutscene):
    cutscene = new_cutscene
    
func add_note_to_q(notes):
    if typeof(notes) == TYPE_ARRAY:
        for note in notes:
            queue.add_notif_to_q(note)
        return
    queue.add_notif_to_q(notes)
    return
    

func _on_move_finished(player):
    print("back to game")
    enter_space_scene(player)
