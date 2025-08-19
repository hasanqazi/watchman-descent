extends Node3D

@export var dialogue: String
@export var time: float

@onready var trigger_col: CollisionShape3D = $Area3D/CollisionShape3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	SignalBus.show_dialogue.emit(dialogue, time)
	queue_free()
