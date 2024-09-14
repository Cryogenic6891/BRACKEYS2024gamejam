extends RigidBody3D

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Movement
var move_speed: float = 5.0  # Speed of forward/backward movement
var rotation_speed: float = 2000  # Speed of rotation (turning)
var acceleration_forward: float = 75000  # Acceleration forward
var acceleration_backward: float = 12000 # Acceleration backward

# Buoyancy
var float_force: float = 16
var water_drag: float = 0.028
var water_angular_drag: float = 0.05
const water_height: float = 0.0
var is_submerged: bool = false
@export var water: MeshInstance3D

# Stabilization
var stabilization_force: float = 2000
var is_capsized: bool = false
var capsized_timer: float = 0.0
var capsized_threshold: float = 5.0

func _physics_process(delta):
	is_submerged = false
	var depth = water.update_wave_heights(global_position) - global_position.y
	if depth > 0:
		is_submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)
	check_capsized(delta)
	
	if Input.is_action_pressed("ui_up"):
		update_audio("MOVING")
	else:
		update_audio("IDLE")
		
	if Input.is_action_just_pressed("TOOT"):
		audio_stream_player_3d.play()
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not is_submerged:
		return
	
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
	stabilize_upright(delta, state)

func stabilize_upright(delta, state: PhysicsDirectBodyState3D) -> void:
	var current_up = transform.basis.y
	var desired_up = Vector3.UP
	var stabilization_torque = current_up.cross(desired_up)
	state.apply_torque_impulse(stabilization_torque * stabilization_force * delta)

func check_capsized(delta: float):
	var up_vector = transform.basis.y
	is_capsized = up_vector.y < -0.2
	if is_capsized:
		capsized_timer += delta
		if capsized_timer >= capsized_threshold and Input.is_action_just_pressed("ui_accept"):
			reset_boat_orientation()
	else:
		capsized_timer = 0.0

func reset_boat_orientation():
	var transform_new = global_transform
	transform_new.basis = Basis()
	global_transform = transform_new
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	capsized_timer = 0.0


func update_audio(audio_name: String):
	if audio_name != audio_stream_player["parameters/switch_to_clip"]:
		audio_stream_player.play()
		audio_stream_player["parameters/switch_to_clip"] = audio_name
