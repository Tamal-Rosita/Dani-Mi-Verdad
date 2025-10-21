@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_character_3d.gd')]

func _get_subsystems() -> Array:
	return [{'name':'Character3d', 'script':this_folder.path_join('subsystem_character_3d.gd')}]