extends Interactable

@export var destination: Marker3D
@export var level: Global.Levels
@export var locked: bool = false
@export var locked_text: String 

var interact_text_override: String

func _ready() -> void:
	interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
	interact_text = update_interact_text(locked)

func interact(_player: CharacterBody3D) -> void:
	super(_player)
	
	SignalBus.changed_level.emit(level)
	_player.global_position = destination.global_position
	_player.global_rotation = destination.global_rotation

func update_interact_text(locked: bool) -> String:
	if locked:
		return locked_text
	else:
		return interact_text_override
