extends Node2D


var capture_area: Area2D
var is_in_zone = false
var fish: Area2D
var score = 0
var fish_quantity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_minigame()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	catch_fish(fish)
	update_score_label()
	
func _start_minigame() -> void:
	capture_area = $CaptureArea

func update_score_label() -> void:
	var score_label_node = $CanvasLayer/ScoreLabel
	var fish_count_label = $CanvasLayer/FishCountLabel
	score_label_node.text = "Score: " + str(score)
	fish_count_label.text = "Fish Count: " + str(fish_quantity)

#This monitors keyboard press and provides a pentaly for pressing it whilly nilly
#It also feeds the fish information to the calculator function
func catch_fish(fish) -> void:
	if Input.is_action_just_pressed("space_key") && is_in_zone == true:
		print("Space_Pressed")
		fish_point_calculator(fish)
		fish.queue_free()
	elif Input.is_action_just_pressed("space_key") && is_in_zone == false:
		print("Pentalty")
		score -= 1
	else:
		pass

func fish_point_calculator(fish) -> void:
	var fish_score = (100 - abs(fish.position.x+$FishSpawner.position.x)) * 1
	print("FISH CAUGHT! A " + str(fish_score) + " Pointer! With a value of: " + str(fish.fish_value))
	score += fish_score + fish.fish_value
	fish_quantity += 1

func _on_capture_area_area_entered(area: Area2D) -> void:
	is_in_zone = true
	fish = area
	
func _on_capture_area_area_exited(area: Area2D) -> void:
	is_in_zone = false
