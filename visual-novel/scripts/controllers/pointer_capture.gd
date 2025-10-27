extends Node

func _process(_delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_ESCAPE) or Input.is_action_just_pressed("dialogic_default_action"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_just_pressed("dialogic_default_action"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
