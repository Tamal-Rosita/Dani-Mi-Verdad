class_name ControllerPlayerThirdPerson extends ControllerPlayer

var _cam_pivot: Node3D

func _on_controlled_obj_change():
	super._on_controlled_obj_change()	
	_cam_pivot = controlled_obj.get_node("CameraPivot")
	if _cam_pivot.camera:
		_cam_pivot.camera.make_current()
		
func get_input_tracking() -> Vector3:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	input = input.rotated(-_cam_pivot.rotation.y)
	return Vector3(input.x, 0.0, input.y)
	
func process_unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_cam_pivot.rotate_view(event.relative)