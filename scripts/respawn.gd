extends TextureButton

@export var respawn_dest: Marker3D
@export var player: Node3D

@onready var items := get_tree().get_nodes_in_group("item")

func _on_pressed() -> void:
	player.global_position = respawn_dest.global_position
	player.global_rotation = respawn_dest.global_rotation
	player.head.global_rotation = respawn_dest.global_rotation

	items = get_tree().get_nodes_in_group("item")
	for node: Node3D in items:
		if node.has_method("set_visible"):
			node.set_visible(true)
		elif "visible" in node:
			node.visible = true
	
	player.respawn_button.visible = false
	Global.player_immobile = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
