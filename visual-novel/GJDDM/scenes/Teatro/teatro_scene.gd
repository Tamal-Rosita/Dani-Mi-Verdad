extends Node3D

@export var next_scene: PackedScene

const dialogic_var: String = "theatre_talk_with_celia" 

@onready var quest_control: Control = $QuestControl 

func _ready() -> void:
	quest_control.visible = not Dialogic.VAR.get_variable(dialogic_var)
	Dialogic.VAR.variable_changed.connect(_on_var_changed)
	
func _on_var_changed(info: Dictionary) -> void:
	if info["variable"] == dialogic_var:
		quest_control.visible = not info["new_value"]

func _on_next_scene_body_entered(body: Node3D) -> void:
	if body is Player and Dialogic.VAR.get_variable(dialogic_var):
		call_deferred("_deferred_change_scene")
		
func _deferred_change_scene() -> void:
	SceneLoader.change_scene_to_packed(next_scene)
