extends Node2D


onready var START
onready var Characters = $GameBoard/Characters
onready var BoardCharacter = preload("res://board/BoardCharacter.tscn")
onready var Board = $GameBoard
onready var GUI = $UI/GUI
onready var BoardNotification = preload("res://interface/UI/BoardNotification.tscn")
onready var CombatArenaScene = preload("res://combat/CombatArena.tscn")
signal turn_finished(player, scene)
var game
var num_players
var current_player
var turn_ind

func _ready():
    var dummy = BoardCharacter.instance()
    current_player = dummy
    
func initialize(characters, _game):
    game = _game
    game.board = self
    START = $GameBoard/Start.get_position()
    for character in characters:
        character.set_position(START)
        Characters.add_child(character, true)
        character.connect("last_move_taken", self, "show_confirm_popup", [], CONNECT_DEFERRED)
        character.connect("turn_finished", self, "on_board_character_moves_finished", [], CONNECT_DEFERRED)
    num_players = Characters.get_child_count()
    turn_ind = Characters.get_child_count() - 1
    Board.initialize()
    GUI.initialize(self)
    $GameBoard/Spawners/MushBossSpawner.spawn_pawn()
    current_player = characters[0]

func refresh_after_load():
    var characters = Characters.get_children()
    num_players = characters.size()
    
    for character in characters:
        character.set_position(character.last_space)
        character.connect("last_move_taken", self, "show_confirm_popup", [], CONNECT_DEFERRED)
        character.connect("turn_finished", self, "on_board_character_moves_finished", [], CONNECT_DEFERRED)
    num_players = Characters.get_child_count()
    Board.initialize()
    GUI.initialize(self)
    GUI.show()
    game.initialize_game(self)
    ControlsHandler.clear_controls()
    ControlsHandler.give_player_ui_control(current_player.player)
    play_turn(current_player, current_player.get_camera_position())

func start_game():
    GUI.hide()
    var cutscene = game.load_cutscene("res://dialogue/intro_cutscene.json")
    yield(cutscene, "tree_exited")
    GUI.show()
    ControlsHandler.give_player_ui_control(game.get_node("Players").get_child(0))
    play_turn(Characters.get_child(0), START)
    
func play_turn(board_character, last_camera_position):
    print ("board starting " + board_character.player_name + "'s turn")
    current_player = board_character
    
    # Transition to new player
    GUI.change_player(board_character.player)
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
        scene = $GameBoard.get_space_scene(current_player)
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
    
func new_turn_on_load():
    refresh_pathing()
    
func refresh_pathing():
    $GameBoard/Pathfinder.initialize($GameBoard)

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
    GUI.show_action_menu()
    
func enter_shop(player_pawn, location):
    var _shop = ShopFactory.get_shop(player_pawn, location)
    
func play_gui(gui : Node):
    $UI.add_child(gui)
func show_confirm_popup():
    $UI/GUI/MoveConfirmPopup.show()

