extends Node3D
#@onready var paused: Control = $Paused
@onready var game: Node3D = $"."

@onready var Car: VehicleBody3D = $VehicleWheel3D
@onready var canvas_layer: CanvasLayer = $CameraPivot/Camera3D/CanvasLayer

@onready var end: Area3D = $Area3D

@onready var pause_screen = preload("res://Scenes/paused.tscn").instantiate()

func _ready() -> void:
	pass
	
#main paused
func _process(_delta: float) -> void:
	
	#print(node)
	
	if Input.is_action_just_pressed("paused"):
		print("paused pressed")
		pause_game()
	
		
	
	
func pause_game():
	get_tree().paused = true
	game.add_child(pause_screen)

func unpause_game():
	get_tree().paused = false
	game.remove_child(pause_screen)












#restarting
func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().reload_current_scene()
