extends Node3D

@export var smooth_speed := 8.0

func _process(delta):
	global_position = global_position.lerp(
		get_parent().global_position,
		delta * smooth_speed
	)
