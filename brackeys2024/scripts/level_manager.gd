extends Node

var game_running:bool = false
var pause = preload("res://ui/pause.tscn")
var ui = preload("res://ui/in_game_ui.tscn")
var tidal_wave = preload("res://scenes/tidal_moving.tscn")
var hurricane = preload("res://scenes/hurricane_moving.tscn")

var phase = 1

var in_game_ui
var levels:Dictionary = {1:{"scene":"res://scenes/map_1.tscn","timer":1,"goal":10000}}
@onready var viewport_width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var viewport_height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
var tutorial = true
var tutorial_map = {0:"TIP:\nFind the fish shadows to catch them!",1:"TIP:\nPress space or enter when the image lines up\n with the hook", 2:"TIP:\nYou can hold up to 20 fish bring them \n to the dock to score them"}
var pause_menu

var tide_spawns = []
var tide_chance = 0.0
var hurricane_spawns = []
var hurricane_chance = 0.0

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
	StageTimer.connect("new_second",roll_for_hazard)
	add_child(pause_menu)
	StageTimer.start_timer()
	if tutorial:
		initiate_display(tutorial_map[0])

func _process(_delta):
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
	phase = int(phase)
	match phase:
		1:
			light.light_color = morning_light
		2:
			light.light_color = afternoon_light
			tide_chance += 0.2
		3:
			light.light_color = storm_light
			tide_chance += 0.2
			hurricane_chance += 0.025

func roll_for_hazard():
	var tide_check = randf_range(0,1)
	var hurricane_check = randf_range(0,1)
	if tide_check < tide_chance:
		spawn_tidal_wave()
	if hurricane_check < hurricane_chance:
		spawn_hurricane()

func spawn_tidal_wave():
	if tide_spawns.is_empty():
		tide_spawns.append_array(get_tree().get_nodes_in_group("tidespawn"))
	var new_tide = tidal_wave.instantiate()
	var spawn_loc = tide_spawns.pick_random()
	var dir
	if spawn_loc.name.containsn("FORWARD"):
		dir = Vector3.FORWARD
	if spawn_loc.name.containsn("BACK"):
		dir = Vector3.BACK
	if spawn_loc.name.containsn("LEFT"):
		dir = Vector3.LEFT
	if spawn_loc.name.containsn("RIGHT"):
		dir = Vector3.RIGHT
	new_tide.transform.origin = spawn_loc.global_position
	new_tide.tidal_direction = dir
	add_child(new_tide)

func spawn_hurricane():
	if hurricane_spawns.is_empty():
		hurricane_spawns.append_array(get_tree().get_first_node_in_group("hurricanespawn").get_children())
	var new_hurricane = hurricane.instantiate()
	var spawn_loc = hurricane_spawns.pick_random()
	print("hurricane spawned")
