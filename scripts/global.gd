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
