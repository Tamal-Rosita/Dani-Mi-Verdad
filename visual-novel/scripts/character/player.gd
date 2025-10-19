@icon("res://visual-novel/scripts/icons/player3d_icon.svg")

class_name Player extends NovelCharacter

signal interaction_toggle

var _interaction_character: DialogicNpc
	
@onready var _interaction_hud: InteractionHud = $InteractionHUD
@onready var _cam_pivot: ThirdPersonCamera = $CamPivot

func _ready() -> void:
	_interaction_hud.visible = false	
	Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	Dialogic.timeline_started.connect(_on_dialogic_timeline_started)	
	
func _on_dialogic_timeline_ended() -> void:
	if _cam_pivot.camera:
		_cam_pivot.camera.make_current()
	interaction_toggle.emit(false)
	
func _on_dialogic_timeline_started() -> void:
	transform = _interaction_character.player_transform
	interaction_toggle.emit(true)
	
func _unhandled_input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed("interact"):
				play_interaction()
				
func show_interaction(npc_character: DialogicNpc) -> void:
	_interaction_character = npc_character
	_interaction_hud.update_character_interaction(npc_character.character.display_name)
	_interaction_hud.visible = true

func hide_interaction() -> void:
	_interaction_hud.visible = false
	
func play_interaction() -> void:
	if _interaction_character.timeline == null: 
		print_rich("[color=yellow]No timeline loaded to NPC")
		return		
	start_dialogue(_interaction_character.timeline)

func start_dialogue(timeline: DialogicTimeline) -> void:
	if Dialogic.current_timeline != null: return
	Dialogic.start(timeline)
	get_viewport().set_input_as_handled()
