extends Node

const PIRATE_CATCH_A_PARROT_INTENSITY_1 = preload("res://sounds/Pirate Catch a Parrot Intensity 1.wav")
var jukebox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jukebox = AudioStreamPlayer.new()
	UI.connect("volume_changed",update_volume)
	add_child(jukebox)
	jukebox.set_stream(PIRATE_CATCH_A_PARROT_INTENSITY_1)
	jukebox.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_volume():
	jukebox.volume_db = linear_to_db(UI.volume)
