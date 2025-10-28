extends ColorRect

func _ready() -> void:
	color = Color.RED 

func _on_novel_character_interaction_toggle(value: bool) -> void:
	color = Color.GREEN if value else Color.RED
