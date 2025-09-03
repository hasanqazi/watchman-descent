extends Node3D


@onready var point_1: Marker3D = $Point1
@onready var point_2: Marker3D = $Point2

@export var player: CharacterBody3D

var progress_thresholds: Array[float] = [0.8, 0.6, 0.4, 0.2]
var triggered_thresholds: Dictionary = {}
var dialogue_texts: Dictionary = {
	0.8: "You're 80% of the way there!",
	0.6: "You're 60% of the way there!",
	0.4: "You're 40% of the way there!",
	0.2: "You're almost there!"
}
var dialogue_time: float = 2.0

func _ready() -> void:
	triggered_thresholds.clear()
	for t: float in progress_thresholds:
		triggered_thresholds[t] = false

func _process(_delta: float) -> void:
	if Global.current_level == Global.Levels.FOREST:
		var total_distance: float = point_1.global_position.distance_to(point_2.global_position)
		var player_distance: float = player.global_position.distance_to(point_2.global_position)
		var progress: float = 1.0 - (player_distance / total_distance)
		for t: float in progress_thresholds:
			if progress >= t and not triggered_thresholds[t]:
				SignalBus.show_dialogue.emit(dialogue_texts[t], dialogue_time)
				triggered_thresholds[t] = true
