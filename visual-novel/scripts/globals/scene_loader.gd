extends Node

# TODO: Update with default not in project dir.
var loading_screen: PackedScene = preload("res://visual-novel/GJDDM/scenes/Title/loading_screen.tscn")

var next_scene: String

func change_scene_to_packed(scene: PackedScene) -> void:
	change_scene_to(scene.resource_path) 

func change_scene_to(scene_name: String) -> void:
	next_scene = scene_name
	get_tree().change_scene_to_packed(loading_screen)
