extends Control

@onready var panel = $Panel
@onready var volume = $Panel/Main/Volume/HSlider

func _ready():
	volume.value = UI.volume

func _on_resume_pressed():
	get_tree().paused = false
	panel.visible = false


func _on_h_slider_value_changed(value):
	UI.volume_change(value)


func _on_exit_game_pressed():
	panel.visible = false
	LevelManager.game_running = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")
