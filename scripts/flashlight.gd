extends Interactable

var interact_text_override: String = "Pickup [%s]" % Global.interact_bind

@onready var spotlight: SpotLight3D = %SpotLight3D
@onready var audio_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var powered: bool = false

func _ready() -> void:
	interact_text = interact_text_override
	spotlight.visible = false

func interact(_player: CharacterBody3D) -> void:
	super(_player)
	SignalBus.add_item_to_inv.emit(self)
	#queue_free()

func activate() -> void:
	if powered:
		spotlight.visible = false
		powered = false
		audio_stream.play()
	else:
		spotlight.visible = true
		powered = true
		audio_stream.play()
