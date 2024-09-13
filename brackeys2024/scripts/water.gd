extends MeshInstance3D

# Shader variables
var material: ShaderMaterial
const M_2PI = 6.283185307
const M_6PI = 18.84955592
var wave_speed: float
var wave_size: Vector2
var wave_height: float
var time = 0.0

func _ready():
	material = mesh.surface_get_material(0)
	wave_speed = material.get_shader_parameter("wave_speed")
	wave_size = material.get_shader_parameter("wave_size")
	wave_height = material.get_shader_parameter("height")

func global_to_uv(pos: Vector3) -> Vector2:
	var uv_x = pos.x / global_transform.basis.x.length()
	var uv_y = pos.z / global_transform.basis.z.length()
	return Vector2(uv_x, uv_y)

func calculate_wave_height(uv: Vector2, current_time: float) -> float:
	uv *= wave_size
	var d1 = fmod(uv.x + uv.y, M_2PI)
	var d2 = fmod((uv.x + uv.y + 0.25) * 1.3, M_6PI)
	
	d1 = current_time * 0.07 + d1
	d2 = current_time * 0.05 + d2
	
	var dist = Vector2 (sin(d1) * 0.15 + sin(d2) * 0.05, cos(d1) * 0.15 + cos(d2) * 0.05)
	return dist.y * wave_height

func update_wave_heights(global_positions):
	var wave_heights
	var uv = global_to_uv(global_positions)
	var height = calculate_wave_height(uv, time)
	return height

func _process(delta: float):
	time += delta * wave_speed
	material.set_shader_parameter("time", time)
