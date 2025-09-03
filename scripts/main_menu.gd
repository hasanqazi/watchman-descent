extends Node3D

@export var intro_scene: String
@export var button_sound: AudioStream

func _on_play_pressed() -> void:
	SignalBus.play_options_audio.emit(button_sound)
	SceneLoader.load_scene(intro_scene)


func _on_quit_pressed() -> void:
	SignalBus.play_options_audio.emit(button_sound)
	get_tree().quit()


func _on_options_pressed() -> void:
	SignalBus.play_options_audio.emit(button_sound)
	SignalBus.toggle_options.emit(true)
