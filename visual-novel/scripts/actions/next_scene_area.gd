extends Area3D

@export var scene: PackedScene 

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body is Player:
		print(body.dialogic_character.display_name)
		get_tree().change_scene_to_packed(scene)