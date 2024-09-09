extends CharacterBody3D


# Movement variables
var move_speed: float = 5.0  # Speed of forward/backward movement
var rotation_speed: float = 1.5  # Speed of rotation (turning)
var acceleration_forward: float = 2.0  # Acceleration forward
var acceleration_backward: float = 0.5 # Acceleration backward
var deceleration: float = 0.75 # Water drag

func _physics_process(delta: float) -> void:
	
	# player input
	var forward_input = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	
	# rotation
	rotation.y += turn_input * rotation_speed * delta
	
	# forward direction based on rotation
	var forward_direction = -transform.basis.z
	
	
	# accelerate or decelerate forward movement
	var target_speed = forward_input * move_speed
	if forward_input > 0: # forward acceleration
		velocity = velocity.move_toward(forward_direction * target_speed, acceleration_forward * delta)
	elif forward_input <0: # backward acceleration
		velocity = velocity.move_toward(forward_direction * target_speed, acceleration_backward * delta) 
	else: #decelerate
		velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	# move ship
	move_and_slide()
