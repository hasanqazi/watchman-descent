extends Node

var player_immobile: bool = false
var flashlight_powered: bool = false


var interact_bind: String = InputMap.action_get_events("interact")[0].as_text().replace(" (Physical)", "")

enum Levels {
	FOREST,
	MAZE,
	MIRROR
}

var current_level: Levels

func center_string(text: String) -> String:
	return "[center]%s[/center]" % text

func type_dialogue_sequence(label: RichTextLabel, lines: Array[String], typerwriter_player: AudioStreamPlayer, typing_speed := 0.03, sound_interval := 5) -> void:
	for line in lines:
		label.text = ""
		var count: int = 0
		for char in line:
			label.text += char
			if count % sound_interval == 0:
				typerwriter_player.pitch_scale = randf_range(0.75, 0.85)
				typerwriter_player.play()
			count += 1
			await get_tree().create_timer(typing_speed).timeout
		
		await wait_for_space()
	
	SceneLoader.load_scene("res://scenes/overworld.tscn")

func wait_for_space() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			break
