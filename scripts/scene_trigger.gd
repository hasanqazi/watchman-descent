extends Node3D


func _on_area_3d_body_entered(_body: Node3D) -> void:
	SignalBus.toggle_sprite.emit()
