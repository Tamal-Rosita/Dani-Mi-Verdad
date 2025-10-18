@icon("res://visual-novel/scripts/icons/player3d_icon.svg")

class_name Player
extends NovelCharacter

signal dialogue_focus

func set_dialogue(active: bool) -> void:
	if Dialogic.current_timeline != null:
		return
	dialogue_focus.emit(active)
	
	get_viewport().set_input_as_handled()
	Dialogic.start('teatro_cinematica01')
	
	