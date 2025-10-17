extends CharacterBody3D

class_name Player

@export_category("Locomotion")
@export var speed: float = 2
@export var jump_strength: float = 3

@onready var move_action: ActionNode = $ActionContainer/Move
@onready var jump_action: ActionNode = $ActionContainer/Jump

func _ready() -> void:
	move_action.speed = speed
	jump_action.JUMP_STRENGTH = jump_strength