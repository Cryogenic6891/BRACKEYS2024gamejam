extends Node2D

@onready var hook: Sprite2D = %Hook_Sprite2D

@onready var catch_audio_player: AudioStreamPlayer = $Catch_AudioStreamPlayer
@onready var crit_audio_player: AudioStreamPlayer = $Crit_AudioStreamPlayer
@onready var miss_audio_player: AudioStreamPlayer = $Miss_AudioStreamPlayer

var player
var capture_area: Area2D
var is_in_zone = false
var fish: Area2D
var score: int
var fish_quantity: int
var total_fish_spawned: int
var total_fish_this_level: int

var hook_position
var hook_rotation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_fish_spawned = $FishSpawner.fish_spawn_total
	hook_position = hook.position
	hook_rotation = hook.rotation

	player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	catch_fish(fish)
	update_score_label()
	monitor_end_of_minigame()
	
func monitor_end_of_minigame() -> void:
	if total_fish_spawned == total_fish_this_level:
		player.is_fishing = false
		var subview_port = get_parent().get_node("%SubViewport")
		var game_view = subview_port.get_parent()
		game_view.visible = false
		await get_tree().create_timer(2).timeout
		UI.score += score
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
		play_hook_anim()
		
		fish_point_calculator(fishes)
		fish.queue_free()
		fish_quantity += 1
	elif Input.is_action_just_pressed("space_key") && is_in_zone == false:
		score -= 10
		play_hook_anim()
		miss_audio_player.play()

func fish_point_calculator(fishes) -> void:
	var fish_score = fish_location_calculator(fishes)
	score += fish_score * fishes.fish_value
	if fish_score > 0.90:
		crit_audio_player.play()
	else:
		catch_audio_player.play()
		
func fish_location_calculator(fishes):
	var fish_loc = (100 - abs(-fishes.position.x-650))/100
	return fish_loc

func _on_capture_area_area_entered(area: Area2D) -> void:
	is_in_zone = true
	fish = area
	
func _on_capture_area_area_exited(_area: Area2D) -> void:
	is_in_zone = false
	total_fish_this_level += 1
	fish_quantity += 1
	
	
func play_hook_anim() -> void:
	var tween = create_tween()
	
	tween.tween_property(hook, "position", Vector2(0.0, -120.0), .25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(hook, "rotation_degrees", -5, .25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(hook, "position", hook_position, .2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(hook, "rotation_degrees", hook_rotation, .25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
