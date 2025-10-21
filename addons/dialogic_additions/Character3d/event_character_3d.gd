@tool
extends DialogicEvent
class_name DialogicCharacter3dEvent

# Define properties of the event here
var character: DialogicCharacter = null
var mood: String = ""
var amount: float = 0.5

## Used to set the character resource from the unique name identifier and vice versa
var character_identifier: String:
	get:
		if character:
			var identifier := DialogicResourceUtil.get_unique_identifier(character.resource_path)
			if not identifier.is_empty():
				return identifier
		return character_identifier
	set(value):
		character_identifier = value
		character = DialogicResourceUtil.get_character_resource(value)
		

func _execute() -> void:
	# This will execute when the event is reached
	if mood.is_empty():
		finish()
		return
	
	print("Setting " + character.display_name + " avatar mood: "+ mood +" ("+ str(amount) +").")
	
	var dictionary: Dictionary = {
		"character": character.display_name, 
		"mood": mood,
		"amount": str(amount)
	}
	Dialogic.signal_event.emit(dictionary)
	
	finish() # called to continue with the next event


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Character 3D"
	set_default_color('Color2')
	event_category = "Main"
	expand_by_default = true


#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "character_3d"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
		"character"			: {"property": "character_identifier", "default": ""},
		"mood"				: {"property": "mood", "default": "happy"},
		"amount"			: {"property": "amount", "default": "0.5"}
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_edit("character_identifier", ValueType.DYNAMIC_OPTIONS,
			{'file_extension' 	: '.dch',
			'mode'				: 2,
			'suggestions_func' 	: get_character_suggestions,
			'empty_text' 		: '(No one)',
			'icon' 				: load("res://addons/dialogic/Editor/Images/Resources/character.svg")},
			'do_any_characters_exist()')
	add_body_edit("mood", ValueType.SINGLELINE_TEXT)
	add_body_edit("amount", ValueType.NUMBER)
	
func do_any_characters_exist() -> bool:
	return not DialogicResourceUtil.get_character_directory().is_empty()
	
func get_character_suggestions(search_text:String) -> Dictionary:
	return DialogicUtil.get_character_suggestions(search_text, character, true, false, editor_node)

#endregion
