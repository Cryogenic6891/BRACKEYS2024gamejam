extends Node2D

var capture_area: Area2D
var is_in_zone = false
var fish: Area2D
var score = 0
var fish_quantity: int
var total_fish: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_fish = $FishSpawner.fish_spawn_total
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	catch_fish(fish)
	update_score_label()
	monitor_end_of_minigame()
	
func monitor_end_of_minigame():
	if total_fish == fish_quantity:
		var subview_port = get_parent().get_node("%SubViewport")
		var game_view = subview_port.get_parent()
		game_view.visible = false
		queue_free()

func update_score_label() -> void:
	var score_label_node = $CanvasLayer/ScoreLabel
	var fish_count_label = $CanvasLayer/FishCountLabel
	score_label_node.text = "Score: " + str(score)
	fish_count_label.text = "Fish Count: " + str(fish_quantity)

#This monitors keyboard press and provides a pentaly for pressing it whilly nilly
#It also feeds the fish information to the calculator function
func catch_fish(fishes) -> void:
	if Input.is_action_just_pressed("space_key") && is_in_zone == true:
		print("Space_Pressed")
		fish_point_calculator(fishes)
		fish.queue_free()
	elif Input.is_action_just_pressed("space_key") && is_in_zone == false:
		print("Pentalty")
		score -= 1
	else:
		pass

func fish_point_calculator(fishes) -> void:
	var fish_score = (100 - abs(fishes.position.x+$FishSpawner.position.x)) * 1
	print("FISH CAUGHT! A " + str(fish_score) + " Pointer! With a value of: " + str(fishes.fish_value))
	score += fish_score + fishes.fish_value
	

func _on_capture_area_area_entered(area: Area2D) -> void:
	is_in_zone = true
	fish = area
	
func _on_capture_area_area_exited(_area: Area2D) -> void:
	is_in_zone = false
	fish_quantity += 1
