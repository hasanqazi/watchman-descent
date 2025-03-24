extends Node3D

@export var player: CharacterBody3D
@export var maze_enemy: PackedScene = preload("res://scenes/maze_enemy.tscn")
@export var mirror_enemy: PackedScene = preload("res://scenes/mirror_enemy.tscn")
var spawn_points: Array[Node] = []
@onready var spawn_timer: Timer = $SpawnTimer
@onready var mirror_timer: Timer = $MirrorTimer
const MIN_SAFE_DIST: float = 10.0
var previous_level = null

func _ready() -> void:
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	
	mirror_timer.connect("timeout", _on_mirror_timer_timeout)

func _physics_process(_delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	
	# Check for level change to Mirror level
	if previous_level != Global.current_level and Global.current_level == Global.Levels.MIRROR:
		mirror_timer.start()
	
	previous_level = Global.current_level
	
	if Global.current_level == Global.Levels.MAZE:
		var enemies: Array = get_tree().get_nodes_in_group("enemies")
		
		if enemies.size() == 0 and not spawn_timer.time_left > 0:
			spawn_timer.start()
	else:
		spawn_timer.stop()

func _on_spawn_timer_timeout() -> void:
	if Global.current_level == Global.Levels.MAZE:
		spawn_maze_enemy()

# New function for mirror timer timeout
func _on_mirror_timer_timeout() -> void:
	if Global.current_level == Global.Levels.MIRROR:
		spawn_mirror_enemy()

# Keep the original spawn function for maze enemies
func spawn_maze_enemy() -> void:
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

# New separate function for mirror enemies
func spawn_mirror_enemy() -> void:
	var enemy_instance: Node3D = mirror_enemy.instantiate()
	add_child(enemy_instance)
	# Place the mirror enemy at a specific location or near the player
	enemy_instance.global_transform.origin = player.global_transform.origin + Vector3(0, 0, 5)
	print("Mirror Enemy spawned")
