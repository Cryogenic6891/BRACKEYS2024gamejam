extends Marker2D

@onready var fish_node = preload("res://scenes/fish.tscn")

func _on_fish_spawn_timer_timeout() -> void:
	var new_fish = fish_node.instantiate()
	add_child(new_fish)
