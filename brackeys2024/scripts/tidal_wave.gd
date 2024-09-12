extends AnimatableBody3D

var tidal_speed: float = 20
@export var tidal_direction: Vector3 = Vector3.RIGHT
var force_multiplier: float = 10.0
var upward_force: float = 500.0
var tumble_torque: Vector3 = Vector3(0, 500, 500)

func _physics_process(delta):
	var collision = move_and_collide(tidal_direction * tidal_speed * delta)
	collision
	if collision:
		var collided_object = collision.get_collider()
		if collided_object is RigidBody3D:
			apply_force(collided_object)

func apply_force(obj: RigidBody3D):
	var total_force = tidal_direction.normalized() * force_multiplier
	total_force += Vector3(0, upward_force, 0)
	obj.apply_central_impulse(total_force)
	
	var random_torque = tumble_torque * Vector3(randf(), randf(), randf()).normalized()
	obj.apply_torque_impulse(random_torque)
