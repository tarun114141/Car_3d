extends Control
@onready var resolution_button: OptionButton = $VBoxContainer/Resolution

var resolutions := {
	"1280 x 720": Vector2i(1280, 720),
	"1600 x 900": Vector2i(1600, 900),
	"1920 x 1080": Vector2i(1920, 1080)
}
# ANTI ALIASING
enum AntiAliasing { OFF, FXAA, MSAA_2X, MSAA_4X }


var anti_aliasing: int = AntiAliasing.OFF

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
	for r in resolutions.keys():
		resolution_button.add_item(r)
		resolution_button.text=r

	resolution_button.select(0)
	apply_texture_detail()
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	pass







	
	








	



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
	get_tree().change_scene_to_file("res://Scenes/car.tscn")
	queue_free()
	

func _on_aa_options_item_selected(index: int) -> void:
	print("AA_sucess")
	anti_aliasing = index
	apply_anti_aliasing()
	
	
func apply_anti_aliasing():
	var viewport := get_viewport()
	if viewport == null:
		return

	# Reset MSAA
	viewport.msaa_3d = Viewport.MSAA_DISABLED

	# FXAA via WorldEnvironment
	var env_node := get_tree().get_first_node_in_group("WorldEnv")
	if env_node and env_node.environment:
		env_node.environment.fxaa_enabled = false

	match anti_aliasing:
		AntiAliasing.OFF:
			pass

		AntiAliasing.FXAA:
			if env_node and env_node.environment:
				env_node.environment.fxaa_enabled = true

		AntiAliasing.MSAA_2X:
			viewport.msaa_3d = Viewport.MSAA_2X

		AntiAliasing.MSAA_4X:
			viewport.msaa_3d = Viewport.MSAA_4X


func _on_model_detailing_item_selected(index: int) -> void:
	draw_distance = index
	print("DD_sucess")


func _on_fps_item_selected(index: int) -> void:
	match index:
		0:
			fps_limit = 30
		1:
			fps_limit = 60
		2:
			fps_limit = 120
		3:
			fps_limit = 0  # Unlimited

	Engine.max_fps = fps_limit
	print("fps_sucess")


func _on_d_d_options_item_selected(index: int) -> void:
	draw_distance = index
	print("DD_sucess")


func _on_t_detail_options_item_selected(index: int) -> void:
	texture_detail = index
	print("texture detailing")
	apply_texture_detail()


func _on_resolution_item_selected(index: int) -> void:
	var key = resolution_button.get_item_text(index)
	DisplayServer.window_set_size(resolutions[key])


func _on_back_pressed() -> void:
	visible=false
