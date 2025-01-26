extends Interactable

var interact_text_override: String = "Pickup [%s]" % Global.interact_bind

func _ready() -> void:
	interact_text = interact_text_override

func interact() -> void:
	SignalBus.play_interact_audio.emit(interact_sound)
	queue_free()
