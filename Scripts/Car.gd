extends VehicleBody3D

var start = false
@export var MAX_STEER= 0.6
@onready var smoke: CPUParticles3D = $CPUParticles3D

@onready var reverse_camera: Camera3D = $SubViewport/reverse_camera
@onready var reverse_screen: TextureRect = $TextureRect


@export var ENGINE_POWER= 3500


@export var max_brake=5000
@onready var rear_left: VehicleWheel3D = $R_left
@onready var rear_right: VehicleWheel3D = $R_right
@onready var front_left: VehicleWheel3D = $F_left
@onready var front_right: VehicleWheel3D = $F_right
@onready var engine_sfx: AudioStreamPlayer3D = $Engine_sfx

#Gear
@export var gears := {
	-1: { "max_speed": 45.0,  "mult": -3.00 }, 
	 0: { "max_speed": 0.0,   "mult":  0.00 },

	 1: { "max_speed": 60.0,  "mult":  3.80 }, 
	 2: { "max_speed": 100.0, "mult":  2.60 }, 
	 3: { "max_speed": 140.0, "mult":  2.00 }, # Increased from 1.55
	 4: { "max_speed": 180.0, "mult":  1.75 }, # Increased from 1.20
	 5: { "max_speed": 220.0, "mult":  1.55 }, # Increased from 1.00
	 6: { "max_speed": 260.0, "mult":  1.45 }  # Increased from 0.85
}

var current_gear := 0
var time_passed



var prev_speed := 0.0
var acceleration := 0.0


var speed_limit

@onready var gear_label: Label = $CameraPivot/Camera3D/CanvasLayer/gear_label
@onready var speed_label: Label = $CameraPivot/Camera3D/CanvasLayer/speed_label
@onready var timer: Label = $CameraPivot/Camera3D/CanvasLayer/timer





# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	reverse_screen.visible=false
	
	time_passed=0.0
	
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@export var drift_friction_limit := 2.5
@export var normal_friction_slip := 10.5
@export var drift_speed_threshold := 50.0 # km/h
@export var drift_steering_threshold := 0.3

func _physics_process(delta: float) -> void:
	var offset=  Vector3(-transform.basis.z * 1.8 + transform.basis.y * 1.5 )  
		 
	reverse_camera.global_transform.origin = global_transform.origin + offset
	reverse_camera.global_transform.basis=global_transform.basis
	
	if current_gear==-1:
		reverse_screen.visible=true
	else:
		reverse_screen.visible=false
		
	
	
	
	var speed_mps = linear_velocity.length()
	var speed_kmh = speed_mps * 3.6
	
	# Detect drift intensity based on steering and speed
	var steer_input = abs(Input.get_axis("right", "left"))
	var drift_intensity = 0.0
	
	if speed_kmh > drift_speed_threshold and steer_input > drift_steering_threshold:
		drift_intensity = (steer_input - drift_steering_threshold) / (1.0 - drift_steering_threshold)
		drift_intensity *= clamp(speed_kmh / 200.0, 0.5, 1.5)
	
	# Apply dynamic friction slip to rear wheels
	var target_friction = lerp(normal_friction_slip, drift_friction_limit, clamp(drift_intensity, 0.0, 1.0))
	rear_left.wheel_friction_slip = lerp(rear_left.wheel_friction_slip, target_friction, delta * 5.0)
	rear_right.wheel_friction_slip = lerp(rear_right.wheel_friction_slip, target_friction, delta * 5.0)

	# Scales steering down from 100% at 0 km/h to about 15% at 250 km/h
	var steer_amount = MAX_STEER * clamp(1.0 - (speed_kmh / 300.0), 0.15, 1.0)
	steering = move_toward(steering, Input.get_axis("right", "left") * steer_amount, delta * 2.5)
	
	var throttle = Input.get_action_strength("throttle") 
	
	#if start:
	engine_sfx.pitch_scale = lerp(engine_sfx.pitch_scale, 0.6 + (speed_kmh / gears[current_gear]["max_speed"]) + (throttle * 0.2) if current_gear > 0 else 0.4 + throttle, 0.1)
	#smoke.initial_velocity_max=throttle* (speed_kmh/100)
	
	var gear_data = gears[current_gear]

	#var gear_max_speed = gear_data["max_speed"]
	var gear_mult = gear_data["mult"]
	speed_limit= gear_data["max_speed"]
	#print(current_gear)
	

	if speed_kmh < speed_limit : 
		rear_left.engine_force= (throttle * ENGINE_POWER  * gear_mult)/2
		rear_right.engine_force=(throttle * ENGINE_POWER * gear_mult)/2
	else:
		rear_left.engine_force  = 0.0
		rear_right.engine_force = 0.0
		
	if Input.is_action_pressed("clutch"):
		rear_left.engine_force  = 0.0
		rear_right.engine_force = 0.0
	#print(speed_kmh)
	var brake_input=Input.get_action_strength("brake")
	front_left.brake=brake_input * max_brake
	front_right.brake=brake_input * max_brake
	
	rear_left.brake= (brake_input * max_brake) * 0.3
	rear_right.brake=(brake_input * max_brake) * 0.3
	front_left.brake=brake_input* max_brake
	front_right.brake=brake_input* max_brake
	
	
	
	
	acceleration = (speed_mps - prev_speed) / delta
	prev_speed = speed_mps
	speed_label.text= str(int(speed_kmh))
	gear_label.text=str(current_gear)
	#print(acceleration)
	#print("Speed:", speed_kmh, "km/h  Accel:", acceleration, "m/s²")
	#print("left",rear_left.engine_force)
	
	time_passed += delta
	timer.text = format_time(time_passed)
	
	#Engine breaks
	if throttle == 0 and speed_kmh > 1 or Input.is_action_pressed("clutch"):
	# Simulates engine compression slowing the car
		rear_left.brake = 50.0 
		rear_right.brake = 50.0
	
	
	
#func _input(event):
	#if event.is_action_pressed("up_shift"):
		#if(current_gear==0) :
			#if Input.is_action_pressed("clutch"):
				#current_gear=1
				#print("no")
		#else:
			#return
		#current_gear = min(current_gear+1,gears.size()-2)
		#print("yes")
	#elif event.is_action_pressed("down_shift"):
		#current_gear = max(current_gear- 1, -1)
		
	

	
	
func _input(event):
	if event.is_action_pressed("up_shift"):
		if(current_gear != 0 and current_gear != -1) :
				current_gear = min(current_gear + 1, gears.size()-2)
				
			
		else:
			if Input.is_action_pressed("clutch"):
				if current_gear==0:
					current_gear=1
				if current_gear== -1:
					current_gear=0
			return
		
	elif event.is_action_pressed("down_shift"):
		if(current_gear != 0 and current_gear != -1) :
			current_gear = max(current_gear - 1, -1)
		else:
			if Input.is_action_pressed("clutch"):
				
				current_gear=-1
				print("yes")
				

func format_time(t: float) -> String:
	var minutes = int(t) / 60
	var seconds = int(t) % 60
	return "%02d:%02d" % [minutes, seconds]




	
