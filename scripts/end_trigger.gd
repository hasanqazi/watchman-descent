extends Node3D


func _on_area_3d_body_entered(_body: Node3D) -> void:
	print(Global.current_level)
	if Global.current_level == Global.Levels.MIRROR:
		SignalBus.open_gate.emit()
		SignalBus.toggle_sprite.emit()
		
		print("Gate opened")
		queue_free()
