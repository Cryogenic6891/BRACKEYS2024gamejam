extends Area2D

@export var speed = 150
@export var fish_value = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish_value = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fish_swimming(delta)

# To move fish across the screen
func fish_swimming(delta) -> void:
	position.x -= (speed * delta)
