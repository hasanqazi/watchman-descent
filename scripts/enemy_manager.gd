extends Node3D

@export var player: CharacterBody3D
@export var maze_enemy: PackedScene = preload("res://scenes/maze_enemy.tscn")
var spawn_points: Array[Node] = []
@onready var spawn_timer: Timer = $SpawnTimer
const MIN_SAFE_DIST: float = 10.0

func _ready() -> void:
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	spawn_timer.wait_time = 10.0
	spawn_timer.one_shot = true
	
func _physics_process(_delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	
	if Global.current_level == Global.Levels.MAZE:
		var enemies: Array = get_tree().get_nodes_in_group("enemies")
		
		if enemies.size() == 0 and not spawn_timer.time_left > 0:
			spawn_timer.start()
	else:
		spawn_timer.stop()

func _on_spawn_timer_timeout() -> void:
	if Global.current_level == Global.Levels.MAZE:
		spawn_enemy()

func spawn_enemy() -> void:
	#var valid_spawn_points = []
	var player_pos: Vector3 = player.global_transform.origin
	
	var sorted_spawn_points: Array = spawn_points.duplicate()
	sorted_spawn_points.sort_custom(func(a: Node, b: Node) -> bool: 
		return a.global_transform.origin.distance_to(player_pos) < b.global_transform.origin.distance_to(player_pos)
	)
	
	var spawn_point: Node = null
	
	for point: Node in sorted_spawn_points:
		if point.global_transform.origin.distance_to(player_pos) >= MIN_SAFE_DIST:
			spawn_point = point
			break
	
	if spawn_point == null and sorted_spawn_points.size() > 0:
		spawn_point = sorted_spawn_points[-1]
	
	if spawn_point:
		var enemy_instance: Node3D = maze_enemy.instantiate()
		add_child(enemy_instance)
		enemy_instance.global_transform.origin = spawn_point.global_transform.origin
		print("Maze Enemy spawned")
