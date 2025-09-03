extends AudioStreamPlayer

func _ready() -> void:
	SignalBus.play_options_audio.connect(play_options_audio)

func play_options_audio(audio: AudioStream) -> void:
	if audio != null:
		stream = audio
		play()
	else:
		pass
