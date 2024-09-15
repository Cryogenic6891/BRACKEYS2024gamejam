extends Control

@onready var panel = $Panel
@onready var volume = $Panel/Main/Volume/HSlider

func _on_resume_pressed():
	get_tree().paused = false
	panel.hide()
	StageTimer.pause_timer(false)

func _on_h_slider_value_changed(value):
	UI.volume_change(value/10.0)

func _on_exit_game_pressed():
	panel.hide()
	LevelManager.game_running = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/title_screen.tscn")
	LevelManager.quit()
	StageTimer.pause_adjustment = 0
	queue_free()
