extends Area3D

@export var scene: PackedScene 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Player and Dialogic.VAR.get_variable("can_travel"):
		call_deferred("_deferred_change_scene")
		
func _deferred_change_scene() -> void:
	SceneLoader.change_scene_to_packed(scene)