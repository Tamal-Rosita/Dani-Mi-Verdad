extends Area3D

@export var scene: PackedScene 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().change_scene_to_packed(scene)