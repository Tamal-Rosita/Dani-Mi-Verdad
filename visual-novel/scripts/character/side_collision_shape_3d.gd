extends CollisionShape3D


@export var  LERP_VALUE : float = 0.15

var _movement_class: MovementState 
var _movement_manager: MovementStateManager

@onready var _character: CharacterBody3D = $".."

func _ready() -> void:
	_movement_manager = _character.find_child("MovementManager")
	if !_movement_manager:
		for child in _character.get_children():
			if child is MovementState:
				_movement_class = child
				break

func _process(_delta: float) -> void:
	# face camera rotation

	var has_input = _movement_manager.active_state.input_direction != Vector3.ZERO \
					if _movement_manager else \
					_movement_class.input_direction != Vector3.ZERO
	
	if !is_equal_approx(_character.velocity.length_squared(), 0.0) and has_input:
		face_point(_character.velocity, LERP_VALUE)


# runs in local space
func face_point(point: Vector3, lerp_value : float = 0.0) -> void:
	if point.is_equal_approx(Vector3.ZERO):
		return
	StaticFunc.rotate_y_to_point(self, point, lerp_value)
