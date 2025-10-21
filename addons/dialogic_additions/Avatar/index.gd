@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_avatar.gd')]

func _get_subsystems() -> Array:
	return [{'name':'Avatar', 'script':this_folder.path_join('subsystem_avatar.gd')}]