extends Node3D


@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var world_ambience: AudioStreamPlayer = $AmbientSound

var forest_env: Environment = preload("res://resources/forest.tres")
var maze_env: Environment = preload("res://resources/maze.tres")
var mirror_env: Environment = preload("res://resources/mirror.tres")

var forest_ambience: AudioStreamWAV = preload("res://resources/forest_ambience.tres")

var levers: int = 0
var max_levers: int = 2

func _ready() -> void:
	SignalBus.changed_level.connect(changed_level)
	SignalBus.lever_switched.connect(lever_switched)
	
	world_environment.environment = forest_env

func changed_level(level: Global.Levels) -> void:
	match level:
		Global.Levels.FOREST:
			world_environment.environment = forest_env
			world_ambience.stream = forest_ambience
		Global.Levels.MAZE:
			world_environment.environment = maze_env
		Global.Levels.MIRROR:
			world_environment.environment = mirror_env
	
	print("Player travelled to level ", level)

func lever_switched() -> void:
	levers = levers + 1
	
	if levers == max_levers:
		print("All levers switched")
		SignalBus.unlock_door.emit()
