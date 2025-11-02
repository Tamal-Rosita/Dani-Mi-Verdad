extends Node3D

@export var next_scene: PackedScene

@onready var quest_canvas_layer: QuestCanvasLayer = $QuestCanvasLayer 

func _ready() -> void:
	quest_canvas_layer.visible = true
	
func _on_next_scene_body_entered(body: Node3D) -> void:
	if body is not NovelCharacter or \
			not body.character_type == NovelCharacter.CharacterType.PLAYER:
		return
	call_deferred("_deferred_change_scene")
		
func _deferred_change_scene() -> void:
	SceneLoader.change_scene_to_packed(next_scene)

func _on_pause_canvas_layer_pause_toggle(value: bool) -> void:
	quest_canvas_layer.is_displayed = not value

func _on_pause_canvas_layer_restarted() -> void:
	pass # Replace with function body.
