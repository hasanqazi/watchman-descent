extends Node3D

@export var player: CharacterBody3D

@onready var player_dest: Marker3D = %PlayerDest

@onready var items := get_tree().get_nodes_in_group("item")

func _ready() -> void:	
	SignalBus.player_respawn.connect(player_respawn)

func player_respawn() -> void:
	items = get_tree().get_nodes_in_group("item")
	for node: Node3D in items:
		if node.has_method("set_visible"):
			node.set_visible(false)
		elif "visible" in node:
			node.visible = false
	
	Global.player_immobile = true
	player.respawn_button.visible = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	player.global_position = player_dest.global_position
	player.global_rotation = player_dest.global_rotation
	player.head.global_rotation = player_dest.global_rotation
	#player.player_cam.global_rotation = player_dest.global_rotation
