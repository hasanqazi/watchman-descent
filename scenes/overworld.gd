extends Node3D


@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var world_ambience: AudioStreamPlayer = $AmbientSound

var forest_env: Environment = preload("res://resources/forest.tres")
var maze_env: Environment = preload("res://resources/maze.tres")

func _ready() -> void:
	SignalBus.changed_level.connect(changed_level)
	
	world_environment.environment = forest_env

func changed_level(level: Global.Levels) -> void:
	match level:
		Global.Levels.FOREST:
			world_environment.environment = forest_env
		Global.Levels.MAZE:
			world_environment.environment = maze_env
	
	print("Player travelled to level ", level)
