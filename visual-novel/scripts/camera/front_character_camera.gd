class_name FrontCharacterCamera extends Node3D

@export_group("CAM")
@export var normal_fov : float = 40.0
@export var closeup_fov : float = 20.0

enum FOV {NORMAL, CLOSEUP}
const CAMERA_BLEND : float = 0.05

@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var camera : Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
	# prevent spring arm from colliding with owning character
	spring_arm.add_excluded_object(get_parent().get_parent().get_rid()) 
	
	
func change_fov(setting: FOV) -> void:
	match setting:
		FOV.NORMAL:
			camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
		FOV.CLOSEUP:
			camera.fov = lerp(camera.fov, closeup_fov, CAMERA_BLEND)
			
func get_cam_forward() -> Vector3:
	return -camera.get_global_transform().basis.z 			