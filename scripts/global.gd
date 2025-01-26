extends Node

var interact_bind: String = InputMap.action_get_events("interact")[0].as_text().replace(" (Physical)", "")

func center_string(text: String) -> String:
	return "[center]%s[/center]" % text
