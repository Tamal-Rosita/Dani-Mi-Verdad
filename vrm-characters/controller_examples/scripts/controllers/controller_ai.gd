extends Controller


@export var INPUT_DELAY: float = 0.5
@export var rotation_angle: float = 90.0
@export var current_direction: Vector3 = Vector3.RIGHT

var _last_input_window: float = 0.0
var _action_container: ActionContainer
var _cam_pivot: Node3D


func _on_controlled_obj_change():
	_action_container = controlled_obj.get_node("ActionContainer")
	_cam_pivot = controlled_obj.find_child("CamPivot", false)


func _process(delta: float) -> void:
	if _last_input_window < 0.0:
		current_direction = current_direction.rotated(Vector3.UP, deg_to_rad(rotation_angle))
		_last_input_window = INPUT_DELAY
	else:
		_last_input_window -= delta
	
	_action_container.play_action("MOVE", {"input_direction":current_direction})
	if _cam_pivot:
		_cam_pivot.set_direction(Vector2(current_direction.x, current_direction.z))
