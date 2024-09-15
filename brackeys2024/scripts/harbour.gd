extends Node3D

@onready var light_pivot: Node3D = %Light_Pivot
var tween

func _ready() -> void:
	tween = create_tween().set_loops()
	
	tween.tween_property(light_pivot, "rotation", Vector3(0.0, 0.0, -90.0), 45).as_relative()
	print(light_pivot)
