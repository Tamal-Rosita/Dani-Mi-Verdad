class_name QuestCanvasLayer extends CanvasLayer

var is_completed:= false

func _on_pause_canvas_layer_pause_toggle(value: bool) -> void:
	if is_completed:
		return
	visible = not value