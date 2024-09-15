extends Node
var volume = 1

signal volume_changed

func exit_game():
	get_tree().quit()

func volume_change(value):
	volume = value
	volume_changed.emit()
