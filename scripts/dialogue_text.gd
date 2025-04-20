extends RichTextLabel

var dialogue_timer: float = -1.0

func _ready() -> void:
	text = ""
	SignalBus.show_dialogue.connect(display_dialogue_text)

func _process(delta: float) -> void:
	if dialogue_timer > 0:
		dialogue_timer -= delta
	if dialogue_timer < 0:
		text = ""

func display_dialogue_text(dialogue: String, time: float) -> void:
	text = Global.center_string(dialogue)
	dialogue_timer = time
