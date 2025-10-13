extends Camera3D

# The target node to follow (assign in the inspector)
@export var target: Node3D

# Which axes to follow the target on
@export var follow_x: bool = true
@export var follow_y: bool = false
@export var follow_z: bool = true

@export var offset: Vector3 = Vector3.ZERO

# Dead zone settings (area where camera doesn't move)
@export var dead_zone_width: float = 4.0    # Total width of dead zone
@export var dead_zone_height: float = 2.0   # Total height of dead zone (Y axis)
@export var dead_zone_depth: float = 4.0    # Total depth of dead zone (Z axis)

# Camera movement speed (0-1 for smoothing, higher = faster)
@export var follow_speed: float = 0.1

# Optional: limits for camera movement
@export var use_limits: bool = false
@export var x_min_limit: float = -10.0
@export var x_max_limit: float = 10.0
@export var z_min_limit: float = -10.0
@export var z_max_limit: float = 10.0

# Debug: Visualize dead zone in editor
@export var show_dead_zone: bool = false

# Internal variables
var _current_position: Vector3

func _ready():
	if target:
		_current_position = global_position
	else:
		push_warning("Camera3D: No target assigned!")

func _process(delta):
	if not target:
		return

	var target_pos = target.global_position
	var new_position = _current_position

	# Calculate half dimensions for dead zone boundaries
	var half_width = dead_zone_width * 0.5
	var half_height = dead_zone_height * 0.5
	var half_depth = dead_zone_depth * 0.5

	# Follow on X axis with dead zone
	if follow_x:
		var x_diff = target_pos.x - _current_position.x 
		if abs(x_diff) > half_width:
			# Move camera to keep target at the edge of dead zone
			new_position.x = target_pos.x - sign(x_diff) * half_width + offset.x

	# Follow on Y axis with dead zone
	if follow_y:
		var y_diff = target_pos.y - _current_position.y
		if abs(y_diff) > half_height:
			new_position.y = target_pos.y - sign(y_diff) * half_height + offset.y
	
	# Follow on Z axis with dead zone
	if follow_z:
		var z_diff = target_pos.z - _current_position.z
		if abs(z_diff) > half_depth:
			new_position.z = target_pos.z - sign(z_diff) * half_depth  + offset.z
	
	# Apply limits if enabled
	if use_limits:
		new_position.x = clamp(new_position.x, x_min_limit, x_max_limit)
		new_position.z = clamp(new_position.z, z_min_limit, z_max_limit)
	
	# Smooth movement
	_current_position = _current_position.lerp(new_position, follow_speed)
	global_position = _current_position

# Optional: Function to instantly reset camera to target
func reset_to_target():
	if target:
		_current_position = target.global_position
		global_position = _current_position

# Optional: Function to change target at runtime
func set_new_target(new_target: Node3D):
	target = new_target

# Debug: Draw dead zone visualization (call this from elsewhere if needed)
func _draw_debug_dead_zone():
	if not show_dead_zone or not is_inside_tree():
		return
	
	# This would need to be implemented with debug drawing in your game
	# For example, using MeshInstance3D with a transparent box
	print("Dead Zone Center: ", global_position)
	print("Dead Zone Size: ", Vector3(dead_zone_width, dead_zone_height, dead_zone_depth))

# Function to check if target is within dead zone
func is_target_in_dead_zone() -> bool:
	if not target:
		return false
	
	var target_pos = target.global_position
	var half_width = dead_zone_width * 0.5
	var half_height = dead_zone_height * 0.5
	var half_depth = dead_zone_depth * 0.5
	
	return (abs(target_pos.x - global_position.x) <= half_width and
			abs(target_pos.y - global_position.y) <= half_height and
			abs(target_pos.z - global_position.z) <= half_depth)

# Function to get dead zone boundaries (useful for visualization)
func get_dead_zone_bounds() -> Dictionary:
	var half_size = Vector3(dead_zone_width * 0.5, dead_zone_height * 0.5, dead_zone_depth * 0.5)
	return {
		"min": global_position - half_size,
		"max": global_position + half_size
	}
