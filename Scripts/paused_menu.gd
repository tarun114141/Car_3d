extends Control

@onready var paused_menu: Control = $"."

@onready var settings_menu: Control = $SettingsMenu


@onready var resume_button: Button = $resume


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.visible=false
	

	
	paused_menu.visible=false
	pass
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	T_paused()
	pass
	
func resume():
	paused_menu.visible=false
	get_tree().paused=false

func paused():
	paused_menu.visible=true
	
	get_tree().paused= true
	
func T_paused():
	if Input.is_action_just_pressed("paused") and get_tree().paused==false:
		
		paused()
	elif Input.is_action_just_pressed("paused") and get_tree().paused==true:
		
		resume()






	


func _on_resume_pressed() -> void:
	resume() # Replace with function body.


func _on_settings_pressed() -> void:
	settings_menu.visible=true
	print("setting is pressed")
	
