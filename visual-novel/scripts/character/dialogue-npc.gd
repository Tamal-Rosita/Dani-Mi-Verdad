extends Node3D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var dialogue_camera: Camera3D = $"../DialogueCamera"

func set_focus(is_focus:bool) -> void:
	animation_tree.set("parameters/conditions/Focus", is_focus)
	animation_tree.set("parameters/conditions/Talk", !is_focus)
	dialogue_camera.current = is_focus

func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	print("enter")
	if body is Player:
		print("Player entered NPC space")
		set_focus(true)


func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	print("exit")
	if  body is Player:
		print("Player exited NPC space")
		set_focus(false) 
	
