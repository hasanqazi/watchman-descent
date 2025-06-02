extends Control

@onready var dialogue: RichTextLabel = %Dialogue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await Global.type_dialogue_sequence(dialogue, [
		"We found it… bodycam footage, still intact. Location matches the last GPS ping - deep in Eldergrove Forest.",
		"Eldergrove Ranger Cabin - Restricted Access \n
		No sign of him... just this camera. Let's see what really happened down there."
	])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
