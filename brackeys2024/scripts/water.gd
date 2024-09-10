extends MeshInstance3D

var material: ShaderMaterial
var noise: Image

var noise_scale: float
var wave_speed: float
var height_scale: float

var time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	material = mesh.surface_get_material(0)
	#noise = material.get_shader_parameter("noise").noise.get_seemless_image(512,512)
	#noise_scale = material.get_shader_parameter("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_height(world_position: Vector3):
	pass
