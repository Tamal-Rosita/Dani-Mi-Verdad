@icon("res://addons/plenticons/icons/16x/creatures/person-red.png")
@tool
class_name NovelCharacter extends CharacterBody3D

@export_enum("Player", "NPC") var character_type: String = "NPC" : set = _set_character_type

@export_category("Dialogic")
@export var dialogic_character: DialogicCharacter

@export_category("VRM")
@export var vrm_scene: PackedScene : set = _set_vrm_scene

@export_category("Camera")
@export var camera_height_offset: float = -0.1 #Offset from top of hear
@export var face_height_ratio: float = 0.9 # 90% of height for face target 

@export_category("Locomotion")
@export var speed: float = 2.0:
	set(v):
		speed = v
		if (move_action != null):
			move_action.speed = speed
					
@export var jump_strength: float = 4.0:
	set(v):
		jump_strength = v
		if (jump_action != null):
			jump_action.JUMP_STRENGTH = jump_strength		

signal interaction_toggle
signal interaction_area_entered
signal interaction_area_exited

var is_busy: bool

# Action Nodes
@onready var move_action: ActionNode = $ActionContainer/Move
@onready var jump_action: ActionNode = $ActionContainer/Jump
## Component nodes
# Public
@onready var camera_pivot: ThirdPersonCamera = $CameraPivot
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var gaze_target: Node3D = $GazeTarget
@onready var interaction_area: Area3D = $CollisionShape3D/InteractionArea3D
@onready var socket: Node3D =  $CollisionShape3D/Socket
# Private
@onready var _animation_tree: CharacterAnimationTree = $AnimationTree
@onready var _front_camera_pivot: FrontCharacterCamera = $CollisionShape3D/FrontCameraPivot
@onready var _model_container = $CollisionShape3D/ModelContainer
@onready var _grounded_movement: MovementGroundedComplex = $MovementManager/GroundedMovement # Improve this!


var _current_animation_player: AnimationPlayer
var _vrm_model: VRMTopLevel

func _ready() -> void:
	if Engine.is_editor_hint():
		# Ensure ModelContainer exists in editor
		if not _model_container:
			var container = Node3D.new()
			container.name = "ModelContainer"
			collision_shape.add_child(container)
			container.set_owner(get_tree().edited_scene_root)	
	else:		
		move_action.speed = speed
		jump_action.jump_strength = jump_strength		
		interaction_area.body_entered.connect(_on_interaction_area_3d_body_entered)
		interaction_area.body_exited.connect(_on_interaction_area_3d_body_exited)				
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
		Dialogic.timeline_started.connect(_on_dialogic_timeline_started)
		## TODO: Replace with signal of custom event (Cameras)?
		Dialogic.Text.speaker_updated.connect(_on_dialogic_speaker_updated) # This is working
		# Dialogic.Portraits.character_joined.connect(_on_dialogic_character_joined) # TODO: Use this as reference for Custom Event
		##		
		if vrm_scene:
			_vrm_model = _instantiate_model(vrm_scene)
			_adjust_camera_nodes()
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not dialogic_character:
		warnings.append("DialogicCharacter resource is not assigned")
	if not vrm_scene:
		warnings.append("VRM scene is not assigned")
	if not _animation_tree:
		warnings.append("AnimationTree node is missing - needed for animations")
	return warnings
	
func _instantiate_model(scene: PackedScene) -> Node3D:
	if not _model_container:
		push_error("ModelContainer is missing!")
		return null
	if not scene:
		push_error("No scene provided to instantiate!")
		return null
	# Clear the current model
	for child in _model_container.get_children():
		child.queue_free()	
	# Instantiate and add the new model
	var new_model = scene.instantiate()
	_model_container.add_child(new_model)
	_connect_animation_player(new_model)
	return new_model
	
func _focus_character() -> void:
	if _front_camera_pivot.camera:
		_front_camera_pivot.camera.make_current()
	
func _set_character_type(value: String) -> void:
	character_type = value
	_update_character_type()
	
func _stop_movement() -> void:
	_grounded_movement.disable_all_movement() # TODO: not working by itself
	_grounded_movement.exit()

func _play_movement() -> void:
	_grounded_movement.enable_all_movement() # TODO: not working by itself (at all?)
	_grounded_movement.enter()
	
func _update_character_type() -> void:
	if not Engine.is_editor_hint():
		return
	# Update script inheritance based on type
	var script = get_script()
	print("Updating character type to " + character_type.to_snake_case() + ". Current script : " + str(script))
	match character_type:
		"Player":
			if not script is GDScript or script.resource_path.get_file() != "player.gd":
				set_script(load("res://visual-novel/scripts/character/player.gd"))
		"NPC":
			if not script is GDScript or script.resource_path.get_file() != "npc.gd":
				set_script(load("res://visual-novel/scripts/character/npc.gd"))
	
func _set_vrm_scene(value: PackedScene) -> void:
	vrm_scene = value
	_refresh_model()
	
func _refresh_model() -> void:
	if not Engine.is_editor_hint():
		return
	if _model_container and vrm_scene:
		_vrm_model = _instantiate_model(vrm_scene)		
#		_adjust_camera_nodes()
		# Wait a frame for the model to be fully instantiated
		call_deferred("_adjust_camera_nodes")
		# Make sure it's editable in editor
		_vrm_model.set_owner(get_tree().edited_scene_root)		
		
func _adjust_camera_nodes() -> void:
#	if not Engine.is_editor_hint():
#		return
	var height: float = _calculate_character_height()
	print("Character height: " + str(height))
	if height > 0:
		_update_node_heights(height)
		
func _calculate_character_height() -> float:
	var aabb: AABB = _get_character_aabb()
	if aabb.has_volume():
		return aabb.size.y
	return 0.0

func _get_character_aabb() -> AABB:
	var aabb: AABB
	for mesh in _get_all_mesh_instances():
		var mesh_transform = mesh.global_transform
		var mesh_aabb = mesh.get_aabb()
		mesh_aabb = AABB(mesh_transform * mesh_aabb.position, mesh_aabb.size)
#		print("Mesh name: " + mesh.name + " with volume: " + str(mesh_aabb.get_volume()))
		if aabb.has_volume():
			aabb = aabb.merge(mesh_aabb)
		else:
			aabb = mesh_aabb
	return aabb

func _get_all_mesh_instances() -> Array[MeshInstance3D]:
	var meshes: Array[MeshInstance3D] = []
	for child in _model_container.get_children():
		if child.name == _vrm_model.name: # Taking both characters: new and old, need to filter.
			_collect_mesh_instances(child, meshes)
	return meshes

func _collect_mesh_instances(node: Node, meshes: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		meshes.append(node as MeshInstance3D)
	for child in node.get_children():
		_collect_mesh_instances(child, meshes)

func _update_node_heights(height: float) -> void:
	# Top of head + small offset
	var adjusted_height = height + camera_height_offset
	# Adjusted height to face ratio
	var face_height = adjusted_height * face_height_ratio
	# Adjust camera pivots 
	if camera_pivot:
		camera_pivot.position.y = adjusted_height 
	# Child of CollisionShape
	if _front_camera_pivot:
		_front_camera_pivot.position.y = face_height - collision_shape.position.y
	# Adjust face target (e.g., for dialogic look-at)
	if gaze_target:
		gaze_target.position.y = face_height

		
func _connect_animation_player(model_node: Node) -> void:
	# Find AnimationPlayer in the VRM model
	var animation_player: AnimationPlayer = _find_animation_player(model_node)	
	if animation_player and _animation_tree:
		_current_animation_player = animation_player
		_animation_tree.anim_player = _animation_tree.get_path_to(animation_player)
#		print("AnimationPlayer connected to AnimationTree: ", animation_player.name)
	elif _animation_tree:
		push_warning("No AnimationPlayer found in VRM model for AnimationTree")

func _find_animation_player(node: Node) -> AnimationPlayer:
	# Recursively search for AnimationPlayer
	if node is AnimationPlayer:
		return node as AnimationPlayer	
	for child in node.get_children():
		var result: AnimationPlayer = _find_animation_player(child)
		if result:
			return result	
	return null
	
#func _on_dialogic_character_joined(info: Dictionary) -> void:
#	print("Timeline character joined")
#	print(info)
	
func _on_dialogic_speaker_updated(new_character: DialogicCharacter) -> void:
	if new_character == null: return
#	print("Speaker updated: " + new_character.display_name + ":" + character.display_name)
	if new_character == dialogic_character:
#		print("Focusing on: " + new_character.display_name)
		_focus_character()
		
func _on_dialogic_timeline_ended() -> void:
	is_busy = false
	_animation_tree.reset()
	interaction_toggle.emit(false)
	
func _on_dialogic_timeline_started() -> void:
	is_busy = true
	_animation_tree.reset()
	_stop_movement()
	interaction_toggle.emit(true)
	
func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	if  body is not NovelCharacter or body == self:
		return
	interaction_area_entered.emit(body as NovelCharacter)
	#print("Entered character interaction area")

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	if  body is not NovelCharacter or body == self:
		return
	interaction_area_exited.emit(body as NovelCharacter)
#	print("Exited character interaction area")
