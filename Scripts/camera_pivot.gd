extends Node3D

@export var smooth_speed := 8.0

@export var camera:Array[Camera3D] 
var current_idx= 0;

func _ready() -> void:
	pass
	
func _process(delta):
	global_position = global_position.lerp(
		get_parent().global_position,
		delta * smooth_speed
	)
	if Input.is_action_just_pressed("switch"):
		current_idx=(current_idx+1)%camera.size()
		update_cam()
	

		

func update_cam():
	for i in range(camera.size()):
		camera[i].current=(i==current_idx)
	
