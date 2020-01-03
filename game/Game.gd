extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn")
onready var CombatArena = preload("res://combat/CombatArena.tscn")
var board
var queue
func _ready():
    var main_menu = MainMenu.instance()
    main_menu.initialize(self)
    add_child(main_menu)
    
func set_controls():
    $ControlsHandler.initialize($Players)
    for player in $Players.get_children():
        player.board_character.player_id = player.get_id()
        player.controls = $ControlsHandler.get_controls(player.get_id())
    
func enter_space_scene(player_pawn):
    var scene = $Board/GameBoard.get_space_scene(player_pawn)
    board = get_node("Board")
    queue = board.get_node("NotificationQueue")
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
    print("ended scene, or no scene available")
    var queue = board.get_node("NotificationQueue")
    queue.connect("emptied", self, "on_queue_finished")
    #set_process(false)
    queue.play_queue()

    
func on_queue_finished():
    set_process(true)
    board.next_turn()
    
func add_note_to_q(notes):
    for note in notes:
        queue.add_notif_to_q(note)
