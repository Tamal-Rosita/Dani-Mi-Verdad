class_name InteractionHud extends Control

@export var label_template: String = "Press X to interact with %s"
@onready var label: Label = $Label

func _ready() -> void:
	hide()
	
func display(target: String):
	update(target)
	show()
	
func update(other_name: String):
	var text = label_template % other_name
	_update_label(text)

func _update_label(new_text: String):
	label.text = new_text