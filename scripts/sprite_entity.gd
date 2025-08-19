extends Node3D

@onready var anim_player: AnimationPlayer = $sprite/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	anim_player.play("Moving")
	
	SignalBus.turn_on_sprite.connect(turn_on_sprite)

func turn_on_sprite() -> void:
	visible = true
