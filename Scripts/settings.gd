extends Node

# TEXTURE DETAIL
enum TextureDetail { LOW, MEDIUM, HIGH, ULTRA }

var texture_detail: int = TextureDetail.HIGH


enum ModelDetail { LOW, MEDIUM, HIGH, ULTRA }

var model_detail: int = ModelDetail.HIGH

var fps_limit: int = 60

# DRAW DISTANCE
enum DrawDistance { NEAR, MEDIUM, FAR, ULTRA }

var draw_distance: int = DrawDistance.FAR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_texture_detail()
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_m_d_options_item_selected(index: int) -> void:
	Settings.model_detail = index
	print("sucess")


func _on_fps_option_item_selected(index: int) -> void:
	match index:
		0:
			Settings.fps_limit = 30
		1:
			Settings.fps_limit = 60
		2:
			Settings.fps_limit = 120
		3:
			Settings.fps_limit = 0  # Unlimited

	Engine.max_fps = Settings.fps_limit
	print("fps_sucess")
	print(Engine.max_fps)
	


func _on_d_d_option_item_selected(index: int) -> void:
	Settings.draw_distance = index
	print("DD_sucess")


func _on_t_d_options_item_selected(index: int) -> void:
	Settings.texture_detail = index
	print("texture detailing")
	apply_texture_detail()
	



#Tecture function
func apply_texture_detail():
	match texture_detail:
		TextureDetail.LOW:
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/anisotropic_filtering_level",
				1
			)
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/use_mipmaps",
				false
			)

		TextureDetail.MEDIUM:
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/anisotropic_filtering_level",
				2
			)
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/use_mipmaps",
				true
			)

		TextureDetail.HIGH:
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/anisotropic_filtering_level",
				8
			)
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/use_mipmaps",
				true
			)

		TextureDetail.ULTRA:
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/anisotropic_filtering_level",
				16
			)
			ProjectSettings.set_setting(
				"rendering/textures/default_filters/use_mipmaps",
				true
			)

	ProjectSettings.save()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://car.tscn") # Replace with function body.
