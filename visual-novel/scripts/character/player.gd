@tool
class_name Player extends NovelCharacter

@export_category("Camera")
@export var use_override_camera: bool = false

var can_interact: bool
var override_camera: Camera3D

var _interaction_character: Npc

@onready var _interaction_hud: InteractionHud = $InteractionHUD

func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		reset_camera()

func hide_interaction() -> void:
	can_interact = false
	_interaction_hud.hide()
	
func play_interaction() -> void:
	hide_interaction()
	start_dialogue(_interaction_character.timeline)

func reset_camera() -> void:
	if not camera_pivot or not camera_pivot.camera:
		return
	if use_override_camera and override_camera:
		override_camera.make_current()
	elif not use_override_camera:
		camera_pivot.camera.make_current()
	
func show_interaction(npc_character: Npc) -> void:
	if is_busy: 
		return
	_interaction_character = npc_character
	if _interaction_character.timeline == null: 
		print_rich("[color=yellow]No timeline loaded to NPC")
		return
	can_interact = true
	_interaction_hud.display(npc_character.dialogic_character.display_name)
	
func start_dialogue(timeline: DialogicTimeline) -> void:
	if Dialogic.current_timeline != null: return
	Dialogic.start(timeline)
	get_viewport().set_input_as_handled()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()
	# Add player-specific warnings
	return warnings
	
func _on_dialogic_timeline_ended() -> void:
	super._on_dialogic_timeline_ended()
	reset_camera()
	
func _on_dialogic_timeline_started() -> void:
	super._on_dialogic_timeline_started()
	var target_socket: Node3D = _interaction_character.socket
	## Root global_position
	global_position = target_socket.global_position
	var target_euler: Vector3 = Vector3(
		target_socket.global_rotation.x, 
		target_socket.global_rotation.y + deg_to_rad(180), 
		target_socket.global_rotation.z)
	## CollisionShape global_rotation
	collision_shape.global_rotation = target_euler
	
func _unhandled_input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact"):
		play_interaction()
	
#	match event.get_class():
#		"InputEventKey":
