extends Node


onready var MainMenu = preload("res://interface/MainMenu.tscn") 
onready var Cutscene = preload("res://interface/UI/Cutscene.tscn")
onready var CombatArenaScene = preload("res://combat/CombatArena.tscn")
var board
var queue = null
var cutscene = null
var first_turn = true

    
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
    if !first_turn:
        queue.play_queue()
    else:
        first_turn = false

#func _process(_delta):
#  if  Input.is_joy_known(0):
#    print("recognizes_controller")
    
func initialize_game(new_board):
    board = new_board
    queue = $NotificationQueue
    board.connect("tree_entered", queue, "change_ui_node", [board.get_node("UI")])
    queue.ui_parent = board.get_node("UI")
    ControlsHandler.initialize($Players)
    for player in $Players.get_children():
        player.board_character.player_id = player.get_id()
    queue.connect("emptied", self, "on_queue_finished", [], CONNECT_DEFERRED)
    board.connect("turn_finished", self, "_on_move_finished", [], CONNECT_DEFERRED)
    #ControlsHandler.give_player_ui_control($Players.get_child(0))

func enter_space_scene(player_pawn, scene):
    if scene:
        scene.connect("completed", self, "add_note_to_q")     
        scene.connect("tree_exited", self, "resolve_scene")
        if scene is CombatArena:
            $UI/Transition/AnimationPlayer.play("versus")
            yield($UI/Transition, "transitioned")
            remove_child(board)
            add_child(scene)
        elif scene is ShopMenu:
            $UI/Transition/AnimationPlayer.play("transition")
            yield($UI/Transition, "transitioned")
            $BoardManager/UI.add_child(scene)
        else:
            $BoardManager/UI.add_child(scene)
            
            
        scene.initialize(player_pawn.player)
    else:
        # play note q instead?
        print("next turn from game.enter_space")
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
    else:
        queue.add_notif_to_q(notes)
    print("ended scene, or no scene available")
    for child in get_children():
        if child is CombatArena:
            remove_child(child)

func play_transition():
    $UI/Transition/AnimationPlayer.play("transition")
    yield($UI/Transition, "transitioned")
    
func resolve_scene():
    print("resolving scene")
    add_child(board)
    print($UI/Transition/AnimationPlayer.is_playing())
    if $UI/Transition/AnimationPlayer.is_playing():
        yield($UI/Transition/AnimationPlayer, "animation_finished")
    if cutscene:
        play_cutscene(cutscene)
    else:
        queue.play_queue()

func _build_encounter(pawn, enemy, spawner):
    var combat = CombatArenaScene.instance()
    combat.setup(pawn.get_actor(), enemy, spawner)
    return combat

func _on_move_finished(player, scene):
    print("back to game")
    enter_space_scene(player,scene)
