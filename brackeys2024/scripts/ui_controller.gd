extends Node
var volume = 100


func exit_game():
	get_tree().quit()

func volume_change(value):
	volume = value
