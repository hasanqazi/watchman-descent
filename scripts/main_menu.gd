extends Node3D

@export var intro_scene: String


func _on_play_pressed() -> void:
	SceneLoader.load_scene(intro_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	SignalBus.toggle_options.emit(true)
