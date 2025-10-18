extends NovelCharacter

class_name DialogicNpc
	
func _on_interaction_area_3d_body_entered(body: Node3D) -> void:
	super._on_interaction_area_3d_body_entered(body)
	if body is Player:
		print("Player entered NPC space")
		body.set_dialogue(true)
		set_focus(true)	

func _on_interaction_area_3d_body_exited(body: Node3D) -> void:
	super._on_interaction_area_3d_body_exited(body)
	if  body is Player:
		body.set_dialogue(false)
		print("Player exited NPC space")
		set_focus(false) 
