@tool 
class_name Npc extends NovelCharacter

@export_category("Dialogic")
@export var timeline: DialogicTimeline

@onready var player_transform: Transform3D =  $Socket.global_transform

func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	super._on_interaction_area_3d_body_entered(body)
	if body is Player:
		print("Player entered NPC space")
		body.show_interaction(self)

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	super._on_interaction_area_3d_body_exited(body)
	if  body is Player:
		print("Player exited NPC space")
		body.hide_interaction()
