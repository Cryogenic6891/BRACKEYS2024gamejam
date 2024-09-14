extends Control

@onready var main_panel = $BackPanel/Main
@onready var HTP_panel = $BackPanel/HowToPlay
@onready var volume_bar = $BackPanel/Main/Volume/HSlider

func _ready():
	main_panel.visible = true
	HTP_panel.visible = false
	volume_bar.value = UI.volume

func _on_enter_game_pressed():
	LevelManager.start_level(1)

func _on_how_to_play_pressed():
	main_panel.visible = false
	HTP_panel.visible = true

func _on_exit_game_pressed():
	UI.exit_game()

func _on_return_to_main_pressed():
	main_panel.visible = true
	HTP_panel.visible = false

func _on_h_slider_value_changed(value):
	UI.volume_change(value)
