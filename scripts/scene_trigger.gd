extends Node3D


func _on_area_3d_body_entered(_body: Node3D) -> void:
	Global.movement_immobile = true

	SignalBus._on_spawn_end_enemy.emit()
	SignalBus.toggle_sprite.emit()
