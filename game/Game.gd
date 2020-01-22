extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
onready var CombatArena = preload("res://combat/CombatArena.tscn")
var board
var queue = null
func _ready():
    var main_menu = MainMenu.instance()
    main_menu.initialize(self)
    add_child(main_menu)
    
    
func initialize_game(board):
    self.board = board
    queue = board.get_node("NotificationQueue")
    set_controls()
    queue.connect("emptied", self, "on_queue_finished")
    board.connect("turn_finished", self, "_on_move_finished")
    
func set_controls():
    $ControlsHandler.initialize($Players)
    for player in $Players.get_children():
        player.board_character.player_id = player.get_id()
        player.controls = $ControlsHandler.get_controls(player.get_id())
    
func enter_space_scene(player_pawn):
    var scene = $Board/GameBoard.get_space_scene(player_pawn)
    board = get_node("Board")
    if scene != null:
        remove_child(get_node("Board"))
        add_child(scene)
        scene.connect("completed", self, "add_note_to_q")
        scene.initialize()
        yield(scene, "completed")
        add_child(board)
        for player in $Players.get_children():
            if player.stats.health == 0 and player.board_character.death_penalty==0:
               player.board_character.on_killed()
    #TODO: the note q should be at game level?
    print("ended scene, or no scene available")
    #set_process(false)
    queue.play_queue()

func on_queue_finished():
    set_process(true)
    board.next_turn()
    
func add_note_to_q(notes):
    if queue == null:
        queue = board.get_node("NotificationQueue")
        queue.connect("emptied", self, "on_queue_finished")
    if typeof(notes) == TYPE_OBJECT:
        queue.add_notif_to_q(notes)
    return
    for note in notes:
        queue.add_notif_to_q(note)

func _on_move_finished(player):
    print("back to game")
    enter_space_scene(player)
