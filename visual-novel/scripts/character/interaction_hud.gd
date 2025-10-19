class_name InteractionHud extends Control

@export var label_template: String = "Press X to interact with %s"

@onready var label: Label = $Label

func update_character_interaction(character_name: String):
	var text = label_template % character_name
	update_label(text)

func update_label(new_text: String):
	label.text = new_text