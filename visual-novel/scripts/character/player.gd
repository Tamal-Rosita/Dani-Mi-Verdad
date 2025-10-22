class_name Player extends NovelCharacter

var _interaction_character: DialogicNpc
var can_interact: bool
	
@onready var _interaction_hud: InteractionHud = $InteractionHUD
@onready var _cam_pivot: ThirdPersonCamera = $CamPivot

func _ready() -> void:
	super._ready()
	_interaction_hud.visible = false	
	
func _on_dialogic_timeline_ended() -> void:
	super._on_dialogic_timeline_ended()
	if _cam_pivot.camera:
		_cam_pivot.camera.make_current()
	
func _on_dialogic_timeline_started() -> void:
	super._on_dialogic_timeline_started()
	global_transform = _interaction_character.player_transform
	
func _unhandled_input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventKey":
			if Input.is_action_just_pressed("interact") and can_interact:
				play_interaction()
				
func show_interaction(npc_character: DialogicNpc) -> void:
	_interaction_character = npc_character
	if _interaction_character.timeline == null: 
		print_rich("[color=yellow]No timeline loaded to NPC")
		return
	_interaction_hud.update_character_interaction(npc_character.character.display_name)
	can_interact = true
	_interaction_hud.visible = true

func hide_interaction() -> void:
	can_interact = false
	_interaction_hud.visible = false
	
func play_interaction() -> void:
	hide_interaction()
	start_dialogue(_interaction_character.timeline)

func start_dialogue(timeline: DialogicTimeline) -> void:
	if Dialogic.current_timeline != null: return
	Dialogic.start(timeline)
	get_viewport().set_input_as_handled()
