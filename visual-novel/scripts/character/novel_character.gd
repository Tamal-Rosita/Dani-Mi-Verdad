class_name NovelCharacter extends CharacterBody3D

@export_category("Dialogic")
@export var character: DialogicCharacter

@export_category("Locomotion")
@export var speed: float = 2
@export var jump_strength: float = 3

@onready var move_action: ActionNode = $ActionContainer/Move
@onready var jump_action: ActionNode = $ActionContainer/Jump

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var dialogue_camera: Camera3D = $DialogueCamera

func _ready() -> void:
	move_action.speed = speed
	jump_action.JUMP_STRENGTH = jump_strength	
	Dialogic.Text.speaker_updated.connect(_on_dialogic_speaker_updated) # This is working
	
	Dialogic.Portraits.character_joined.connect(_on_dialogic_character_joined) # TODO: Use this as reference for Custom Event
func _on_dialogic_character_joined(info: Dictionary) -> void:
	print("Timeline character joined")
	print(info)
	
func _on_dialogic_speaker_updated(new_character: DialogicCharacter) -> void:
	if new_character == character:
		print("Speaker updated: " + new_character.display_name)
		focus_character(true)
	
		
func focus_character(active: bool) -> void:
	dialogue_camera.make_current()
	## Animation Focus parameter
	animation_tree.set("parameters/conditions/Focus", active)
	## Other parameters
	animation_tree.set("parameters/conditions/Talk", !active)
	
func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	if body is NovelCharacter:
		print("Entered character interaction area")

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	if  body is NovelCharacter:
		print("Exited character interaction area")
