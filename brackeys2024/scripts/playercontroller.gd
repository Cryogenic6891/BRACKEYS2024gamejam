extends RigidBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Movement
var move_speed: float = 3.0  # Speed of forward/backward movement
var rotation_speed: float = 0.5  # Speed of rotation (turning)
var acceleration_forward: float = 1200  # Acceleration forward
var acceleration_backward: float = 600 # Acceleration backward

# Buoyancy
var float_force: float = 1.4
var water_drag: float = 0.028
var water_angular_drag: float = 0.05
const water_height: float = 0.0
var is_submerged: bool = false
@export var water: MeshInstance3D


func _physics_process(_delta):
	var depth = water.update_wave_heights([global_position])[0] - global_position.y
	print(depth)
	is_submerged = false
	if depth > 0:
		is_submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# get delta-time
	var delta = get_physics_process_delta_time()
	
	# player input
	var forward_input = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
		
	
	# rotation as torque
	if turn_input != 0:
		var torque = Vector3.UP * turn_input * rotation_speed
		apply_torque_impulse(torque * delta)
	
	# forward direction based on rotation
	var forward_direction = -transform.basis.z
	
	if forward_input > 0: # forward acceleration
		var forward_force = forward_direction * forward_input * acceleration_forward
		apply_central_force(forward_force * delta)
	elif forward_input <0: # backward acceleration
		var backward_force = forward_direction * forward_input * acceleration_backward
		apply_central_force(backward_force * delta)

	if is_submerged: #smoothed upwards buoyancy
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
