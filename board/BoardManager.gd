extends Node2D


onready var START
onready var PlayerPawnScene = preload("res://board/pawns/PlayerPawn.tscn")
onready var board = get_board()
onready var GUI = $UI/GUI
onready var BoardNotification = preload("res://interface/UI/BoardNotification.tscn")
onready var CombatArenaScene = preload("res://combat/CombatArena.tscn")
onready var fooberg = preload("res://board/Levels/Fooberg/Fooberg.tscn")
onready var party_map = preload("res://board/Levels/test/PartyMap.tscn")

signal turn_finished(player, scene)

var game
var num_players
var Characters 
var current_player : PlayerPawn
var turn_ind

func _ready():
    var dummy = PlayerPawnScene.instance()
    current_player = dummy
    
    
func initialize(characters, _game, mode):
    game = _game
    var b
    if mode == "story":
        b = fooberg.instance()
    elif mode == "party":
        b = party_map.instance()
        
    add_child(b)
    board = b
    
    # need this? at least rename
    game.board = self
    
    Characters = board.get_node("Characters")
    START = get_board().get_pos("start")
    for character in characters:
        character.set_position(START)
        Characters.add_child(character, true)
        character.connect("last_move_taken", self, "show_confirm_popup", [], CONNECT_DEFERRED)
        character.connect("turn_finished", self, "on_board_character_moves_finished", [], CONNECT_DEFERRED)
    num_players = Characters.get_child_count()
    turn_ind = Characters.get_child_count() - 1
    board.initialize()
    GUI.initialize(self)
    
    for spawner in board.get_node("Spawners").get_children():
        if spawner is MobSpawner and spawner.is_boss:
            spawner.spawn_pawn()
    
    current_player = characters[0]
    $Camera2D.current = true

func refresh_after_load():
    var characters = Characters.get_children()
    num_players = characters.size()
    
    for character in characters:
        character.set_position(character.last_space)
        character.connect("last_move_taken", self, "show_confirm_popup", [], CONNECT_DEFERRED)
        character.connect("turn_finished", self, "on_board_character_moves_finished", [], CONNECT_DEFERRED)
    num_players = Characters.get_child_count()
    board.initialize()
    GUI.initialize(self)
    GUI.show()
    game.initialize_game(self)
    ControlsHandler.clear_controls()
    ControlsHandler.give_player_ui_control(current_player.player)
    play_turn(current_player, current_player.get_camera_position())

func start_game():
    GUI.hide()
    if board.start_scene:
        var cutscene = game.load_cutscene(board.start_scene)
        if cutscene:
            yield(cutscene, "tree_exited")
    else:
        SoundManager.play_bgm(board.bgm)
    GUI.show()
    ControlsHandler.give_player_ui_control(game.get_node("Players").get_child(0))
    play_turn(Characters.get_child(0), START)
    
func play_turn(board_character, last_camera_position):
    print ("board starting " + board_character.player_name + "'s turn")
    current_player = board_character
    
    # Transition to new player
    GUI.change_player(board_character.player)
    if get_tree():
        get_tree().paused = true
    board_character.center_camera(last_camera_position)
    yield(board_character, "camera_centered")
    if current_player.turn_penalty > 0 or current_player.player.in_battle:
        $UI/GUI/AnimationPlayer.play("penalty turn")
    else:
        $UI/GUI/AnimationPlayer.play("playable turn")
    yield($UI/GUI/AnimationPlayer, "animation_finished")
    get_tree().paused = false
    
    # re-enable input
    set_process(true)
    set_process_input(true)
    GUI.set_process_input(true)
    board_character.start_turn()
    
    
func on_board_character_moves_finished():
    print("board character turn finished")
    GUI.set_process_input(false)
    var scene = null

    if current_player.can_enter_scene:
        scene = board.get_space_scene(current_player)
        if scene is ChoseEncounterPanel:
            scene.initialize(current_player)
            $UI.add_child(scene)
            var params = yield(scene, "enemy_chosen")
            scene = _build_encounter(params[0], params[1], params[2])
 
    emit_signal("turn_finished", current_player, scene)

func _build_encounter(pawn, enemy, spawner):
    var combat = CombatArenaScene.instance()
    combat.setup(pawn.get_actor(), enemy, spawner)
    return combat

func auto_move(pos, last_camera_pos):
    current_player.auto_move(board.get_moves(current_player.position, pos), last_camera_pos)
    
func new_turn_on_load():
    refresh_pathing()
    
func refresh_pathing():
    board.get_node("Pathfinder").initialize(board)

func next_turn():
    var last_camera_position = current_player.get_camera_position()
    var new_ind = (current_player.get_index() + 1) % num_players
    ControlsHandler.clear_controls()
    ControlsHandler.give_player_ui_control(game.get_node("Players").get_child(new_ind))
    ControlsHandler.current_player = new_ind
    print(InputMap.get_action_list("ui_accept0"))
    play_turn(Characters.get_child(new_ind), last_camera_position)

func view_board():
    current_player.set_process_input(false)
    $BoardViewer.position = current_player.position
    $BoardViewer.show()
    $BoardViewer.set_process_input(true)
    $BoardViewer.set_physics_process(true)
    $BoardViewer/Camera2D.make_current()
    
func return_to_player(last_camera_position):
    $BoardViewer.hide()
    $BoardViewer.set_process_input(false)
    $BoardViewer.set_physics_process(false)
    current_player.center_camera(last_camera_position)
    current_player.set_process_input(true)
    $BoardViewer.moving = false
    
    for child in board.get_children():
        if child is MoveMarker:
            child.queue_free()
    
    GUI.show_action_menu()
    
func enter_shop(player_pawn, location):
    var _shop = ShopFactory.get_shop(player_pawn, location)
    
func play_gui(gui : Node):
    $UI.add_child(gui)
func show_confirm_popup():
    $UI/GUI/MoveConfirmPopup.show()

func show_automove():
    var accesssible_spaces = board.show_automoves(current_player)
    view_board()
    $BoardViewer.moving = true
    
func move_camera(keyword):
    var pos = get_board().get_pos(keyword)
    $Tween.interpolate_property($Camera2D, "position", null, pos, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Camera2D.position = pos
    $Tween.start()
    yield($Tween, "tween_completed")

func on_automove_selected(moves, last_cam_pos):
    current_player.auto_move(moves, last_cam_pos)
    
func get_board():
    for child in get_children():
        if child is TileMap and child.visible:
            return child
