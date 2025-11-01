extends Area3D

@export var message_text: String

@onready var warning_control: Control = $Control
@onready var rich_text_label: RichTextLabel = $Control/RichTextLabel

func _ready() -> void:
	warning_control.visible = false
	rich_text_label.text = message_text

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		warning_control.visible = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player: 
		warning_control.visible = false
