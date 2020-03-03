extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn") 
onready var Cutscene = preload("res://interface/UI/Cutscene.tscn")
onready var CombatArenaScene = preload("res://combat/CombatArena.tscn")
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
    cutscene = null
    get_tree().paused = false
    queue.play_queue()
    
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
    var scene
    
#    if player_pawn.player.in_battle:
#        if !player_pawn.player.battle.get_node("2").get_children():
#            scene $Board/GameBoard.get_space_scene(player_pawn)
#
#    if scene:
#        remove_child(board)
#        add_child(scene)
#        scene.switch_fighters(player_pawn.player.combatant)
#    else:
    scene = $Board/GameBoard.get_space_scene(player_pawn)

    if scene:
        if scene is ChoseEncounterPanel:
            scene.initialize(player_pawn)
            $Board/UI.add_child(scene)
            var params = yield(scene, "enemy_chosen")
            scene = _build_encounter(params[0], params[1], params[2])
        scene.connect("completed", self, "add_note_to_q")
        remove_child(board)
        add_child(scene)
        scene.initialize(player_pawn.player)
    else:
        # play note q instead?
        board.next_turn()

func on_queue_finished():
    set_process(true)
    board.next_turn()
    
func queue_cutscene(new_cutscene):
    cutscene = new_cutscene
    
func add_note_to_q(notes):
    if typeof(notes) == TYPE_ARRAY:
        for note in notes:
            queue.add_notif_to_q(note)
    else:
        queue.add_notif_to_q(notes)
    print("ended scene, or no scene available")
    for child in get_children():
        if child is CombatArena:
            remove_child(child)
         
    add_child(board)
    if cutscene:
        play_cutscene(cutscene)
    else:
        queue.play_queue()

func _build_encounter(pawn, enemy, spawner):
    var combat = CombatArenaScene.instance()
    combat.setup(pawn.get_actor(), enemy, spawner)
    return combat

func _on_move_finished(player):
    print("back to game")
    enter_space_scene(player)
