extends Node3D
@onready var car: VehicleBody3D = $".."

@export var smooth_speed := 1.0
@export var height := 5.0
@export var distance := 10.0
@export var camera:Array[Camera3D]
@onready var camera_3d: Camera3D = $Camera3D
@export var max_cam_rotate= 5;

var current_idx := 0

func _physics_process(delta):

	var steer_input = Input.get_axis("left", "right")
	
	var target_tilt = steer_input * deg_to_rad(max_cam_rotate)
	camera_3d.rotation.z = lerp(
		camera_3d.rotation.z,
		target_tilt,
		delta * 2
	)

	# Calculate position behind car
	var desired_position = car.global_position
	desired_position += -car.global_transform.basis.z * distance
	desired_position.y = car.global_position.y + height

	# Smooth follow
	if current_idx==0:
		camera_3d.global_position = camera_3d.global_position.lerp(
			desired_position,
			delta * smooth_speed
		)

		#camera_3d.look_at(car.global_position, Vector3.UP)

	# Camera switch
	if Input.is_action_just_pressed("switch"):
		current_idx = (current_idx + 1) % camera.size()
		update_cam()


func update_cam():
	for i in range(camera.size()):
		camera[i].current = (i == current_idx)
