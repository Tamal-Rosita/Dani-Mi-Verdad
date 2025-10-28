@tool 
class_name Npc extends NovelCharacter

@export_category("Dialogic")
@export var timeline: DialogicTimeline

func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	super._on_interaction_area_3d_body_entered(body)
	if not timeline: 
		print_rich("[color=yellow]No timeline loaded to NPC")
		return
	if body is Player and not is_busy:
		_animation_tree.reset() # TODO: Improve
		_stop_movement()
		body.show_interaction(self)
		#print("Player entered NPC space")

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	super._on_interaction_area_3d_body_exited(body)
	if not timeline: 
		print_rich("[color=yellow]No timeline loaded to NPC")
		return
	if  body is Player and not is_busy:
		_animation_tree.reset() # TODO: Improve
		_play_movement()
		body.hide_interaction() ## TODO: DEBOUNCE!
		#print("Player exited NPC space")
