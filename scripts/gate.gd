extends Node3D

@onready var anim_player: AnimationPlayer = $gate/AnimationPlayer

func _ready() -> void:
	anim_player.play("Default")
	
	SignalBus.open_gate.connect(open_gate)

func open_gate() -> void:
	anim_player.play("Open")
