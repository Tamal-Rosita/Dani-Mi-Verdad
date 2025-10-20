class_name CharacterMoodAnimTree extends AnimationTree

@export_category("Animation")

@onready var novel_character: NovelCharacter = get_parent() as NovelCharacter
@onready var dialogic_character: DialogicCharacter = novel_character.character
@onready var character_name: String = dialogic_character.display_name

var total_time: int                   = 0
var mood_amount_path: String          = "parameters/FaceExpression/mood_amount/blend_amount"
var mood_state_path: String           = "parameters/FaceExpression/mood/transition_request"	
var viseme_amount_path: String        = "parameters/FaceExpression/viseme_amount/blend_amount"
var viseme_state_path: String         = "parameters/FaceExpression/viseme/transition_request"


func _process(delta):
	total_time += delta
	update_anim(total_time)


func _ready():
	Dialogic.signal_event.connect(_on_dialogic_dictionary_signal)


func update_anim(time: float) -> float:
	var fnl     = FastNoiseLite.new()
	var noise   = fnl.get_noise_1d(time)
	return noise


## Process Dictionary signal sent from Dialogic	
## Take Arguments:
## Dictionary="{"animation":"Dance","character":"ArchLinux-Chan"}
func _on_dialogic_dictionary_signal(argument: Dictionary) -> void:
	if argument["character"] != "All" && argument["character"] != character_name:
		return
	# Face expression
	if argument["mood"] == null && argument["amount"] == null:
		return
	if argument["mood"] != null:
		var mood               = argument["mood"]
		var mood_amount: float = float(argument["amount"])
		print("Setting " + mood + " mood for " + character_name + ": " + mood + " with amount: " + str(mood_amount))
		set(mood_amount_path, mood_amount)
		set(mood_state_path, mood)
