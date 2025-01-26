extends RichTextLabel


func _ready() -> void:
	SignalBus.interact_text.connect(display_text)


func display_text(interact_text: String) -> void:
	text = Global.center_string(interact_text)
