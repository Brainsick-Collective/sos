extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
onready var CombatArena = preload("res://combat/CombatArena.tscn")
onready var Cutscene = preload("res://interface/UI/Cutscene.tscn")
var board
var queue = null
func _ready():
    var main_menu = MainMenu.instance()
    main_menu.initialize(self)
    add_child(main_menu)
    
    
func load_cutscene(cutscene_file):
    var cutscene = Cutscene.instance()
    cutscene.connect("tree_exited", self, "_after_cutscene")
    cutscene.load_dialogue(cutscene_file)
    add_child(cutscene)
    cutscene.play()
    return cutscene
    
func load_board(board):
    pass
    
func _after_cutscene():
    pass
    
func initialize_game(board):
    self.board = board
    queue = get_node("NotificationQueue")
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
    var scene = player_pawn.player.battle
    if scene:
        remove_child(board)
        add_child(scene)
        yield(scene, "completed")
        if player_pawn.player.battle:
            remove_child(scene)
        add_child(board)
    else:
        scene = $Board/GameBoard.get_space_scene(player_pawn)
        board = get_node("Board")
        if scene != null:
            remove_child(get_node("Board"))
            scene.initialize()
            add_child(scene)
            scene.connect("completed", self, "add_note_to_q")
            
            yield(scene, "completed")
            if scene:
                remove_child(scene)
            add_child(board)
            # for player in $Players.get_children():
            #     if player.stats.health == 0 and player.board_character.death_penalty==0:
            #         player.board_character.on_killed(player)
    #TODO: the note q should be at game level?
    print("ended scene, or no scene available")
    #set_process(false)
    queue.play_queue()

func on_queue_finished():
    set_process(true)
    board.next_turn()
    
func add_note_to_q(notes):
    if typeof(notes) == TYPE_OBJECT:
        queue.add_notif_to_q(notes)
    return
    for note in notes:
        queue.add_notif_to_q(note)

func _on_move_finished(player):
    print("back to game")
    enter_space_scene(player)
