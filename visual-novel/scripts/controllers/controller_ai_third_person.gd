class_name ControllerAiThirdPerson extends ControllerAi

var _cam_pivot: Node3D

func _on_controlled_obj_change():
	super._on_controlled_obj_change()
	_cam_pivot = controlled_obj.find_child("CameraPivot", false)
	
func _process(delta: float) -> void:
	super._process(delta)
	if _cam_pivot:
		_cam_pivot.set_direction(Vector2(current_direction.x, current_direction.z))
