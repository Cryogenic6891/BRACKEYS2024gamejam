extends Control

var time
@onready var time_text = $MarginContainer/UIBox/TimerBox/StageTimer
@onready var score_text = $MarginContainer/UIBox/ScoreBox/ScoreCounter
@onready var goal_text = $MarginContainer/UIBox/GoalBox/GoalCounter
@onready var tip_box = $TipBox
@onready var tip_message = $TipBox/VBoxContainer/message

func _process(_delta):
	if LevelManager.game_running:
		time_text.text = StageTimer.get_timer()

func display_tip(message):
	tip_message.text = message
	tip_box.visible = true
	await get_tree().create_timer(10).timeout
	tip_box.visible = false
