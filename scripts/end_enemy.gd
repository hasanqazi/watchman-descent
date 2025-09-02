extends Node3D


@export var num_nodes: int = 8
@export var radius: float = 5.0
@export var min_radius: float = 1.0
@export var move_speed: float = 2.0
@export var sprite_texture: Texture2D

@export var end_scene: String
var end_triggered: bool = false

var enemy_nodes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in num_nodes:
		var angle: float = (TAU / num_nodes) * i
		var node: Sprite3D = Sprite3D.new()
		var x: float = radius * cos(angle)
		var z: float = radius * sin(angle)
		node.position = Vector3(x, 0, z)
		node.texture = sprite_texture
		node.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		add_child(node)
		enemy_nodes.append(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if end_triggered:
		return
		
	for node: Sprite3D in enemy_nodes:
		if node.position.length() > min_radius:
			var dir: Vector3 = -node.position.normalized()
			node.position += dir * move_speed * delta
		else:
			end_triggered = true
			trigger_end_scene()
		node.look_at(global_position, Vector3.UP)

func trigger_end_scene() -> void:
	await get_tree().create_timer(2.0).timeout
	await get_tree().process_frame
	SceneLoader.load_scene(end_scene)

func update_target_location(target_location: Vector3) -> void:
	global_position = target_location
