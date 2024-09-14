extends Control

var time
@onready var time_text = $UIBox/MarginContainer/TimerBox/StageTimer


func _process(delta):
	if LevelManager.game_running:
		time_text.text = StageTimer.get_timer()
