extends Node3D

@export var next_scene: PackedScene

const dialogic_var: String = "metro_talk_with_samuel" 

@onready var quest_canvas_layer: CanvasLayer = $QuestCanvasLayer 

func _ready() -> void:
	Dialogic.VAR.set_variable(dialogic_var, false) # TODO: Replace with save state
	quest_canvas_layer.visible = not Dialogic.VAR.get_variable(dialogic_var)
	Dialogic.VAR.variable_changed.connect(_on_var_changed)
	
func _on_var_changed(info: Dictionary) -> void:
	if info["variable"] == dialogic_var:
		quest_canvas_layer.visible = not info["new_value"]

func _on_next_scene_body_entered(body: Node3D) -> void:
	if not Dialogic.VAR.get_variable(dialogic_var) or body is not NovelCharacter or \
			not body.character_type == NovelCharacter.CharacterType.PLAYER:
		return
	call_deferred("_deferred_change_scene")
		
func _deferred_change_scene() -> void:
	SceneLoader.change_scene_to_packed(next_scene)

func _on_pause_canvas_layer_restarted() -> void:
	Dialogic.VAR.set_variable(dialogic_var, false)
