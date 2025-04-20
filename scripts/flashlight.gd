extends Interactable

@export var interact_text_override: String = "Pickup [%s]" % Global.interact_bind
@export var powered: bool = false

@onready var spotlight: SpotLight3D = %FlashlightBulb
@onready var ambient_bulb: SpotLight3D = %AmbientBulb

@onready var audio_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	interact_text = interact_text_override
	spotlight.light_energy = 0
	ambient_bulb.light_energy = 0

func interact(player: CharacterBody3D) -> void:
	super(player)
	SignalBus.add_item_to_inv.emit(self)
	#queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("activate"):
		activate()

func activate() -> void:
	if equipped == true and Global.player_immobile == false:
		powered = !powered
		spotlight.light_energy = 3.0 if powered else 0.0
		ambient_bulb.light_energy = 0.2 if powered else 0.0
		
		Global.flashlight_powered = powered
		print(Global.flashlight_powered)
		
		if audio_stream and audio_stream.stream:
			audio_stream.play()
