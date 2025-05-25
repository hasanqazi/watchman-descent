extends Node3D

@export var intro_scene: String


func _on_play_pressed() -> void:
	SceneLoader.load_scene(intro_scene)
