extends Node3D

@onready var light_pivot: Node3D = $Lighthouse/Light_Pivot


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(light_pivot, "rotation", Vector3(0, 0, -90), 90).as_relative()
