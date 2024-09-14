extends Marker2D

@onready var fish_node = preload("res://scenes/fish.tscn")
const HAMMERHEAD_SHARK = preload("res://assets/textures/Hammerhead Shark.png")
const MEDIUM_FISH = preload("res://assets/textures/Medium Fish.png")
const SMALL_FISH = preload("res://assets/textures/Small Fish.png")

var fish_dictionary = {
	"small":{"fish_points":10,"fish_image":SMALL_FISH},
	"medium":{"fish_points":25,"fish_image":MEDIUM_FISH}, 
	"large":{"fish_points":100,"fish_image":HAMMERHEAD_SHARK}
	}

var fish_spawn_total

func _ready() -> void:
	fish_spawn_total = randi_range(3, 7)

#spawns a fish on timer timeout
func _on_fish_spawn_timer_timeout() -> void:
	if fish_spawn_total > 0:
		var new_fish = fish_node.instantiate()
		var selected_fish = select_fish_size()
		new_fish.fish_value = fish_dictionary[selected_fish]["fish_points"]
		new_fish.get_node("FishSprite").texture = fish_dictionary[selected_fish]["fish_image"]
		add_child(new_fish)
		fish_spawn_total -= 1
	elif fish_spawn_total == 0:
		$FishSpawnTimer.stop
		
		

func select_fish_size():
	randomize()
	var random_fish = randi() % 100 + 1
	var selected_fish
	if random_fish >= 90:
		selected_fish = "large"
		return selected_fish
	elif random_fish >= 60:
		selected_fish = "medium"
		return selected_fish
	else:
		selected_fish = "small"
		return selected_fish
		
