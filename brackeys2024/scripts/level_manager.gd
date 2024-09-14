extends Node

var game_running:bool = false
var pause = preload("res://ui/pause.tscn")
var ui = preload("res://ui/in_game_ui.tscn")

var phase = 1

var in_game_ui
var levels:Dictionary = {1:{"scene":"res://scenes/map_1.tscn","timer":1,"goal":1000}}
@onready var viewport_width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var viewport_height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
var tutorial = true
var tutorial_map = {0:"TIP:\nFind the fish shadows to catch them!",1:"TIP:\nPress space or enter when the image lines up\n with the hook", 2:"TIP:\nYou can hold up to 20 fish bring them \n to the dock to score them"}
var pause_menu

var tide_spawns = []
var hurricane_spawns = []

func start_level(level):
	if not level == 1:
		tutorial = false
	get_tree().change_scene_to_file(levels[level]["scene"])
	StageTimer.end_stage_time = levels[level]["timer"]
	game_running = true
	in_game_ui = ui.instantiate()
	pause_menu = pause.instantiate()
	add_child(in_game_ui)
	in_game_ui.size = Vector2(viewport_width,viewport_height)
	in_game_ui.goal_text.text = str(levels[level]["goal"])
	StageTimer.end_stage_time = levels[level]["timer"]
	StageTimer.connect("phase_changed",process_phase)
	add_child(pause_menu)
	StageTimer.start_timer()
	if tutorial:
		initiate_display(tutorial_map[0])

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and game_running == true:
		pause_menu.panel.visible = true
		StageTimer.pause_timer(true)
		get_tree().paused = true

func quit():
	in_game_ui.queue_free()

func initiate_display(message):
	if in_game_ui:
		in_game_ui.display_tip(message)

func process_phase(new_phase):
	phase = new_phase[0]
	play_phase()

func play_phase():
	var morning_light = Color("ffc79f")
	var afternoon_light = Color("9e3987")
	var storm_light = Color("00295b")
	var light: DirectionalLight3D = get_tree().get_first_node_in_group("skylight")
	match phase:
		1.0:
			light.light_color = morning_light
			print("Phase 1")
		2.0:
			light.light_color = afternoon_light
			print("Phase 2")
		3.0:
			light.light_color = storm_light
			print("Phase 3")
		
