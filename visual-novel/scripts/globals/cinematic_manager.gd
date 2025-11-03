extends Node

var current_cinematic_camera: PhantomCamera3D

func switch_back() -> void:
	if current_cinematic_camera:
		current_cinematic_camera.priority = 0

func switch_to_camera(camera_name: String, priority: int) -> void:
	print("Switch to camera: " + camera_name + " with priority: " + str(priority))
	var cinematic_cameras: Array = get_tree().get_nodes_in_group("CinematicCameras")
	for camera in cinematic_cameras:
		if camera.name == camera_name:
			current_cinematic_camera = camera as PhantomCamera3D
			current_cinematic_camera.priority = priority
	