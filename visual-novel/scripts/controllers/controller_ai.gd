class_name ControllerAi extends Controller

@export var can_control: bool = true

@export var INPUT_DELAY: float = 0.5
@export var rotation_angle: float = 90.0
@export var current_direction: Vector3 = Vector3.RIGHT

var _last_input_window: float = 0.0
var _action_container: ActionContainer

var _npc: NovelCharacter

func _on_controlled_obj_change():
	_action_container = controlled_obj.get_node("ActionContainer")
	_npc = controlled_obj as NovelCharacter
	_npc.interaction_area_entered.connect(_on_interaction_area_entered)
	_npc.interaction_area_exited.connect(_on_interaction_area_exited)
	_npc.interaction_toggle.connect(_on_interaction_toggle)
	
func _on_interaction_area_entered(other: NovelCharacter)-> void:
	if other.dialogic_character.get_instance_id() == _npc.dialogic_character.get_instance_id():
		return
	can_control = false
	# print("Interaction entered character:" + other.dialogic_character.display_name)

func _on_interaction_area_exited(other: NovelCharacter)-> void:
	if other.dialogic_character.get_instance_id() == _npc.dialogic_character.get_instance_id():
		return
	can_control = true
	# print("Interaction exited character:" + other.dialogic_character.display_name)

func _on_interaction_toggle(is_active: bool):
	can_control = not is_active
	print("Player interaction " + ("started" if is_active else "ended"))
	
func _process(delta: float) -> void:
	if not can_control:
		_action_container.stop_action("MOVE") 
		return
	
	if _last_input_window < 0.0:
		current_direction = current_direction.rotated(Vector3.UP, deg_to_rad(rotation_angle))
		_last_input_window = INPUT_DELAY
	else:
		_last_input_window -= delta
	
	_action_container.play_action("MOVE", {"input_direction":current_direction})
