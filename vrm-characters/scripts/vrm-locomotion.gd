extends Node

@export_category("Animation")
@export var initial_anim: String = "Idle"

var total_time: int                = 0

func _process(delta):
	total_time += delta
	update_anim(total_time)

func update_anim(time: float):
	print(time)
	return
	
