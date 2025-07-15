extends Node3D


@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var world_ambience: AudioStreamPlayer = $AmbientSound

var forest_env: Environment = preload("res://resources/forest.tres")
var maze_env: Environment = preload("res://resources/maze.tres")
var mirror_env: Environment = preload("res://resources/mirror.tres")

const FOREST_AMBIENCE: AudioStreamWAV = preload("res://resources/forest_ambience.tres")
const MAZE_AMBIENCE = preload("res://resources/maze_ambience.tres")

@export var door_unlocked_dialogue: Node3D

var levers: int = 0
var max_levers: int = 2

var mirror_blood_nodes: Array = []

func _ready() -> void:
	SignalBus.changed_level.connect(changed_level)
	SignalBus.lever_switched.connect(lever_switched)

	mirror_blood_nodes = get_tree().get_nodes_in_group("mirror_blood")
	for node: Node3D in mirror_blood_nodes:
		if node.has_method("set_visible"):
			node.set_visible(false)
		elif "visible" in node:
			node.visible = false

	door_unlocked_dialogue.trigger_col.disabled = true
	world_environment.environment = forest_env

func changed_level(level: Global.Levels) -> void:
	Global.current_level = level
	match level:
		Global.Levels.FOREST:
			world_environment.environment = forest_env
			world_ambience.stream = FOREST_AMBIENCE
			world_ambience.play()
		Global.Levels.MAZE:
			world_environment.environment = maze_env
			world_ambience.stream = MAZE_AMBIENCE
			world_ambience.play()
			
			SignalBus.light_change.emit()
			
			for node: Node3D in mirror_blood_nodes:
				if node.has_method("set_visible"):
					node.set_visible(true)
				elif "visible" in node:
					node.visible = true
					

		Global.Levels.MIRROR:
			world_environment.environment = mirror_env
	print("Player travelled to level ", level)

func lever_switched() -> void:
	levers = levers + 1
	
	if levers == max_levers:
		print("All levers switched")
		
		door_unlocked_dialogue.trigger_col.disabled = false
		SignalBus.unlock_door.emit(3)
