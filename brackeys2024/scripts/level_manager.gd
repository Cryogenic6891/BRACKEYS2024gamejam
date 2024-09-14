extends Node

var game_running:bool = false
var pause = preload("res://ui/pause.tscn")
var levels:Dictionary = {1:{"scene":"res://scenes/map_1.tscn","timer":12}}
var pause_menu

func start_level(level):
	get_tree().change_scene_to_file(levels[level]["scene"])
	StageTimer.end_stage_time = levels[level]["timer"]
	game_running = true
	pause_menu = pause.instantiate()
	add_child(pause_menu)

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and game_running == true:
		pause_menu.panel.visible = true
		get_tree().paused = true
