extends Node2D


var capture_area: Area2D
var is_in_zone = false
var fish: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_minigame()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	catch_fish(fish)
	
func _start_minigame() -> void:
	capture_area = $CaptureArea

func catch_fish(fish) -> void:
	if Input.is_key_pressed(KEY_SPACE) && is_in_zone == true:
		print("Space_Pressed")
		fish.queue_free()
	else:
		pass

func _on_capture_area_area_entered(area: Area2D) -> void:
	print("FISH!!!!")
	is_in_zone = true
	fish = area
	
func _on_capture_area_area_exited(area: Area2D) -> void:
	print("GONE!!!")
	is_in_zone = false
