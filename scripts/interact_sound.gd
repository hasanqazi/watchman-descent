extends AudioStreamPlayer

func _ready() -> void:
	SignalBus.play_interact_audio.connect(play_interact_audio)

func play_interact_audio(audio: AudioStream) -> void:
	if audio != null:
		stream = audio
		play()
	else:
		pass
