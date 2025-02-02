extends Node3D
class_name Interactable

@export var interactable_name: String
@export var interact_cooldown: float = 0.0
@export var interactable: bool = true
@export var interact_sound: AudioStream
@export var interact_text: String

@export var equipped: bool = false 


func display_interact_text() -> void:
	SignalBus.interact_text.emit(interact_text)

func interact(_player: CharacterBody3D) -> void:
	print("Played %s sound" % interactable_name)
	SignalBus.play_interact_audio.emit(interact_sound)
