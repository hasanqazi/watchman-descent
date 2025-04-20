extends Node3D

@export var dialogue: String
@export var time: float


func _on_area_3d_body_entered(body: Node3D) -> void:
	SignalBus.show_dialogue.emit(dialogue, time)
	queue_free()
