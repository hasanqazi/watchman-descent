extends Interactable

@export var destination: Marker3D

var interact_text_override: String

func _ready() -> void:
	interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
	interact_text = interact_text_override

func interact(_player: CharacterBody3D) -> void:
	super(_player)
	_player.global_position = destination.global_position
	_player.global_rotation = destination.global_rotation
