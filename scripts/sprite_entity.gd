extends Node3D

@onready var anim_player: AnimationPlayer = $sprite/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	anim_player.play("Moving")
	
	SignalBus.toggle_sprite.connect(toggle_sprite)

func toggle_sprite() -> void:
	visible = !visible
