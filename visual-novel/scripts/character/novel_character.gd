@icon("res://addons/plenticons/icons/16x/creatures/person-red.png")
@tool
class_name NovelCharacter extends CharacterBody3D

@export_enum("Player", "NPC") var character_type: String = "NPC" : set = _set_character_type

@export_category("Dialogic")
@export var dialogic_character: DialogicCharacter

@export_category("VRM")
@export var vrm_scene: PackedScene : set = _set_vrm_scene

@export_category("Locomotion")
@export var speed: float = 2:
	set(v):
		speed = v
		if (move_action != null):
			move_action.speed = speed
					
@export var jump_strength: float = 3:
	set(v):
		jump_strength = v
		if (jump_action != null):
			jump_action.JUMP_STRENGTH = jump_strength		

signal interaction_toggle

# Action Nodes
@onready var move_action: ActionNode = $ActionContainer/Move
@onready var jump_action: ActionNode = $ActionContainer/Jump
# Component nodes
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_shape = $"CollisionShape3D"
@onready var dialogue_camera: Camera3D = $DialogueCamera
@onready var interaction_area: Area3D = $InteractionArea3D
@onready var model_container = collision_shape.find_child("ModelContainer")

var _current_animation_player: AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint():
		# Ensure ModelContainer exists in editor
		if not model_container:
			var container = Node3D.new()
			container.name = "ModelContainer"
			collision_shape.add_child(container)
			container.set_owner(get_tree().edited_scene_root)	
	else:		
		## TODO: Verify if necessary:
		move_action.speed = speed
		jump_action.JUMP_STRENGTH = jump_strength
		##
		
		interaction_area.body_entered.connect(_on_interaction_area_3d_body_entered)
		interaction_area.body_exited.connect(_on_interaction_area_3d_body_exited)				
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
		Dialogic.timeline_started.connect(_on_dialogic_timeline_started)
		## TODO: Replace with signal of custom event (Cameras)?
		Dialogic.Text.speaker_updated.connect(_on_dialogic_speaker_updated) # This is working
		# Dialogic.Portraits.character_joined.connect(_on_dialogic_character_joined) # TODO: Use this as reference for Custom Event
		##
		
		if vrm_scene:
			instantiate_model(vrm_scene)
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not dialogic_character:
		warnings.append("DialogicCharacter resource is not assigned")
	if not vrm_scene:
		warnings.append("VRM scene is not assigned")
	if not animation_tree:
		warnings.append("AnimationTree node is missing - needed for animations")
	return warnings
	
func focus_character(active: bool) -> void:
	dialogue_camera.make_current()
	
	## TODO: Verify following parameters
	## Animation Focus parameter
	animation_tree.set("parameters/conditions/Focus", active)
	## Other parameters
	animation_tree.set("parameters/conditions/Talk", !active)
	
func instantiate_model(scene: PackedScene) -> Node3D:
	if not model_container:
		push_error("ModelContainer is missing!")
		return null
	if not scene:
		push_error("No scene provided to instantiate!")
		return null
	# Clear the current model
	for child in model_container.get_children():
		child.queue_free()	
	# Instantiate and add the new model
	var new_model = scene.instantiate()
	model_container.add_child(new_model)
	_connect_animation_player(new_model)
	return new_model
	
func _set_character_type(value: String) -> void:
	character_type = value
	_update_character_type()
	
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
	if model_container and vrm_scene:
		var vrm_model: Node3D = instantiate_model(vrm_scene)
		# Make sure it's editable in editor
		vrm_model.set_owner(get_tree().edited_scene_root)
		
func _connect_animation_player(model_node: Node) -> void:
	# Find AnimationPlayer in the VRM model
	var animation_player: AnimationPlayer = _find_animation_player(model_node)	
	if animation_player and animation_tree:
		_current_animation_player = animation_player
		animation_tree.anim_player = animation_tree.get_path_to(animation_player)
		print("AnimationPlayer connected to AnimationTree: ", animation_player.name)
	elif animation_tree:
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

	
func _on_dialogic_timeline_ended() -> void:
	interaction_toggle.emit(false)
	
func _on_dialogic_timeline_started() -> void:
	interaction_toggle.emit(true)
	
func _on_dialogic_character_joined(info: Dictionary) -> void:
	print("Timeline character joined")
	print(info)
	
func _on_dialogic_speaker_updated(new_character: DialogicCharacter) -> void:
	if new_character == null: return
	# print("Speaker updated: " + new_character.display_name + ":" + character.display_name)
	if new_character == dialogic_character:
		print("Focusing on: " + new_character.display_name)
		focus_character(true)
	
func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	if body is NovelCharacter:
		print("Entered character interaction area")
		return

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	if  body is NovelCharacter:
		print("Exited character interaction area")
		return
