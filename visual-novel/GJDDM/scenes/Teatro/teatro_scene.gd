extends Node3D

@export var next_scene: PackedScene

const dialogic_var: String = "theatre_talk_with_celia" 

@onready var quest_canvas_layer: QuestCanvasLayer = $QuestCanvasLayer

func _ready() -> void:
	quest_canvas_layer.is_displayed = not Dialogic.VAR.get_variable(dialogic_var)
	Dialogic.VAR.variable_changed.connect(_on_var_changed)
	
func _on_var_changed(info: Dictionary) -> void:
	if info["variable"] == dialogic_var:
		quest_canvas_layer.is_completed = info["new_value"]

func _on_next_scene_body_entered(body: Node3D) -> void:
	if not Dialogic.VAR.get_variable(dialogic_var) or body is not NovelCharacter or \
			not body.character_type == NovelCharacter.CharacterType.PLAYER:
		return
	call_deferred("_deferred_change_scene")
		
func _deferred_change_scene() -> void:
	SceneLoader.change_scene_to_packed(next_scene)


func _on_pause_canvas_layer_pause_toggle() -> void:
	Dialogic.VAR.set_variable(dialogic_var, false)

func _on_pause_canvas_layer_restarted(value: bool) -> void:
	quest_canvas_layer.is_displayed = not value
