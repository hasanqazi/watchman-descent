extends Interactable

var opened: bool = false
var interact_text_override: String

@export var locked: bool = false

@onready var anim_play: AnimationPlayer = $AnimationPlayer
@onready var audio_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	anim_play.play("Default")
	interact_text = "Open"
	interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
	
	if locked:
		interact_text = "Locked"

func interact(_player: CharacterBody3D) -> void:
	if not locked:
		if opened:
			interact_text = "Open"
			interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
			interact_text = interact_text_override
			
			anim_play.play("Close")
			audio_stream.play()
			opened = false
		else:
			interact_text = "Close"
			interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
			interact_text = interact_text_override
			
			anim_play.play("Open")
			audio_stream.play()
			opened = true
