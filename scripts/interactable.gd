extends Node3D
class_name Interactable

@export var interactable_name: String
@export var interact_cooldown: float = 0.0
@export var interactable: bool = true
@export var interact_sound: AudioStream
@export var interact_text: String

func display_interact_text() -> void:
	SignalBus.interact_text.emit(interact_text)
