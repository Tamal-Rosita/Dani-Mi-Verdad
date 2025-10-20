extends Node3D

@export var player_controller: Controller
@export var ai_controller: Controller

@export var player_character: Node3D
@export var ai_character: Node3D

var swapped: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			if swapped:
				player_controller.controlled_obj = player_character
				ai_controller.controlled_obj = ai_character
				swapped = false
			else:
				player_controller.controlled_obj = ai_character
				ai_controller.controlled_obj = player_character
				swapped = true
