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
	
func focus_character(active: bool) -> void:
	dialogue_camera.current = active
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
