class_name ThirdPersonCamera extends Node3D

## camera functionality

@export_group("CAM")
@export var sensitivity_x : float = 0.005
@export var sensitivity_y : float = 0.005
@export var normal_fov : float = 45.0
@export var run_fov : float = 75.0
@export var maze_fov : float = 90.0

@export_group("Spring Arm")
@export var auto_set_len : bool = false

enum FOV {NORMAL, RUN, MAZE}
const CAMERA_BLEND : float = 0.05

@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var camera : Camera3D = $SpringArm3D/Camera3D


func _ready() -> void:
	# prevent spring arm from colliding with owning character
	spring_arm.add_excluded_object(get_parent().get_rid()) 
	
	if auto_set_len:
		set_length(spring_arm.global_position.distance_to(camera.global_position))
		

func set_length(value: float) -> void:
	spring_arm.spring_length = value
	
func set_fov(value: float) -> void:
#	camera.fov = lerp(camera.fov, value, CAMERA_BLEND)
	camera.fov = value

func _physics_process(_delta: float) -> void:
	smooth_move_y(0.07) # 0.7 just feels good

func change_fov(setting: FOV) -> void:
	match setting:
		FOV.NORMAL:
			set_fov(normal_fov)
		FOV.RUN:
			set_fov(run_fov)
		FOV.MAZE: 
			set_fov(maze_fov)

func rotate_view(vec: Vector2) -> void:
	rotation.x -= vec.y * sensitivity_y
	rotation.x = clampf(rotation.x, -PI/4, PI/4)
	rotation.y += -vec.x * sensitivity_x
	if spring_arm.top_level:
		spring_arm.rotation = rotation

func set_direction(vec: Vector2) -> void:
	transform = transform.looking_at(Vector3(vec.x, position.y, vec.y))
	if spring_arm.top_level:
		spring_arm.rotation = rotation

func smooth_move_y(weight) -> void:
	# note: spring_arm is marked as top level so transform is not inherited from parent
	# this allows smoothing of movement
	spring_arm.global_position.x = global_position.x
	spring_arm.global_position.y = lerpf(spring_arm.global_position.y, global_position.y, weight)
	spring_arm.global_position.z = global_position.z

func get_cam_forward() -> Vector3:
	return -camera.get_global_transform().basis.z 
