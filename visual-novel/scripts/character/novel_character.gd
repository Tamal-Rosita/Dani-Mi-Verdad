extends CharacterBody3D

class_name NovelCharacter

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
	
func set_focus(is_focus:bool) -> void:
	animation_tree.set("parameters/conditions/Focus", is_focus)
	animation_tree.set("parameters/conditions/Talk", !is_focus)
	dialogue_camera.current = is_focus
	
func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	if body is NovelCharacter:
		set_focus(true)	


func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	if  body is NovelCharacter:
		set_focus(false) 
