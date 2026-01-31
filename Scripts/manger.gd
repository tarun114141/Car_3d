extends Node3D



func _ready() -> void:
	pass
	
	
	
	
func _process(delta: float) -> void:
	pass
	#get_tree().paused
	#get_tree().visible=true
	
#func _unhandled_input(event):
	#if event.is_action_pressed("paused"):
		#get_tree().paused = not get_tree().paused
		#visible=true
		
		#visible = get_tree().paused
	
	

		


		







#restarting
func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().reload_current_scene()
