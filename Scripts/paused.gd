extends Control

@onready var master_bus := AudioServer.get_bus_index("Master")
@onready var sfx_bus := AudioServer.get_bus_index("SfX")
@onready var BG_bus := AudioServer.get_bus_index("Music")
@onready var camera: Camera3D = $CameraPivot/Camera3D

@onready var master: HSlider = $Sound/Master
@onready var music: HSlider = $Sound/Music
@onready var sfx: HSlider = $Sound/SFX

@onready var resolution_button: OptionButton = $Resolution/resolution
@onready var graphics_button: OptionButton = $graphics/graphics
@onready var apply_button: Button = $Apply

@onready var game_manager: Node3D = $".".get_parent()

@onready var viewport := get_viewport()

var resolutions := {
	"1280 x 720": Vector2i(1280, 720),
	"1600 x 900": Vector2i(1600, 900),
	"1920 x 1080": Vector2i(1920, 1080)
}


var selected_resolution: String
var selected_graphics_index: int = 1 # default Medium

# =======================
# READY
# =======================
func _ready():
	var camera = viewport.get_camera_3d()
	# Fill Resolution dropdown
	for res in resolutions.keys():
		resolution_button.add_item(res)

	# Fill Graphics dropdown
	graphics_button.clear()
	graphics_button.add_item("Low")
	graphics_button.add_item("Medium")
	graphics_button.add_item("High")

	# Default selections
	resolution_button.select(0)
	graphics_button.select(1)

	selected_resolution = resolution_button.get_item_text(0)
	selected_graphics_index = 1
	
	print("pause menu ready")


func _apply_resolution():
	if selected_resolution in resolutions:
		DisplayServer.window_set_size(resolutions[selected_resolution])

func _apply_graphics():
	match selected_graphics_index:
		0: # Low
			ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", 0)
		1: # Medium
			ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", 1)
		2: # High
			ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", 2)


func _on_graphics_item_selected(index: int) -> void:
	selected_graphics_index = index # Replace with function body.


func _on_resolution_item_selected(index: int) -> void:
	selected_resolution = resolution_button.get_item_text(index) # Replace with function body.


func _on_button_pressed() -> void:
	_apply_resolution()
	_apply_graphics() # Replace with function body.


func _on_resume_pressed() -> void:
	get_tree().paused = false
	game_manager.unpause_game()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _on_sfx_value_changed(value: float) -> void:
	print("sfx_audio")
	AudioServer.set_bus_volume_db(sfx_bus, value)
	AudioServer.set_bus_mute(sfx_bus, value <= -39)






func _on_master_value_changed(value: float) -> void:
	print("M_audio")
	AudioServer.set_bus_volume_db(master_bus, value)
	AudioServer.set_bus_mute(master_bus, value <= -39)


func _on_music_value_changed(value: float) -> void:
	print("BG_music")
	AudioServer.set_bus_volume_db(BG_bus, value)
	AudioServer.set_bus_mute(BG_bus, value <= -39)# Replace with function body.
