extends Camera3D

var zoom_speed: float = 1.0
var follow_speed: float = 5.0
var camera_distance: float = 200.0
var zoom_limit: Array = [100.0,3000.0]
@export var player_node: RigidBody3D

var target_position: Vector3 = Vector3()
var current_zoom: float

func _physics_process(delta):
	follow_player(delta)

func follow_player(delta):
	if player_node:
		
		global_position.x = player_node.global_position.x
		global_position.z = player_node.global_position.z
		global_position.y = camera_distance
