extends Node

const PIRATE_CATCH_A_PARROT_INTENSITY_1 = preload("res://sounds/Pirate Catch a Parrot Intensity 1.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var jukebox = AudioStreamPlayer.new()
	add_child(jukebox)
	jukebox.set_stream(PIRATE_CATCH_A_PARROT_INTENSITY_1)
	
	jukebox.play()
	jukebox.set_volume_db(-7.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
