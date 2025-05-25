extends Node3D

@export var player: CharacterBody3D
@export var trigger_radius: int = 0.1
@export var run_radius: int = 10
@export var move_speed: float = 20.0

func _process(delta: float) -> void:
	if player == null:
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= run_radius:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta
		
	if distance_to_player <= trigger_radius:
		queue_free()
		
	else:
		look_at(player.global_position)
