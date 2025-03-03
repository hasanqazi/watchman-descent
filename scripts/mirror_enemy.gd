extends Node3D

@export var radius: float = 5.0:
	set(value):
		radius = max(value, 0.1)
		if is_node_ready:
			update_visuals()

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var sphere_visual: MeshInstance3D = $SphereVisual
@onready var cutoff_ring: MeshInstance3D = $CutoffRing

var is_node_ready: bool = false

func _ready() -> void:
	is_node_ready = true
	update_visuals()
	teleport_sprite()

func update_visuals() -> void:
	if not is_node_ready:
		return
	
	update_sphere_visual()
	update_cutoff_ring()
	
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED

func update_sphere_visual() -> void:
	var sphere_mesh: SphereMesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2.0
	
	if sphere_visual.material_override == null:
		var mat: StandardMaterial3D = create_sphere_material()
		sphere_visual.material_override = mat
	
	sphere_visual.mesh = sphere_mesh

func create_sphere_material() -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.5, 1.0, 0.2)
	mat.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
	return mat

func update_cutoff_ring() -> void:
	var cutoff_height: float = radius * 2.0 * 0.6
	var sphere_bottom: float = -radius
	var ring_y: float = sphere_bottom + cutoff_height
	var ring_radius: float = sqrt(cutoff_height * (2.0 * radius - cutoff_height))
	
	var arr_mesh: ArrayMesh = ArrayMesh.new()
	var vertices: PackedVector3Array = PackedVector3Array()
	var indices: PackedInt32Array = PackedInt32Array()
	var segments: int = 32
	
	for i in segments + 1:
		var angle: float = TAU * i / segments
		vertices.append(Vector3(cos(angle) * ring_radius, 0.0, sin(angle) * ring_radius))
	
	for i in segments:
		indices.append(i)
		indices.append((i + 1) % segments)
	
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	cutoff_ring.mesh = arr_mesh
	cutoff_ring.position.y = ring_y
	
	if cutoff_ring.material_override == null:
		var ring_mat: StandardMaterial3D = StandardMaterial3D.new()
		ring_mat.albedo_color = Color.RED
		ring_mat.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
		cutoff_ring.material_override = ring_mat

func teleport_sprite() -> void:
	var cutoff_height: float = radius * 2.0 * 0.6  # 60% of total sphere height
	var valid_y_min: float = -radius + cutoff_height
	var cos_theta_min: float = valid_y_min / radius
	
	var cos_theta: float = randf_range(cos_theta_min, 1.0)
	var theta: float = acos(cos_theta)
	var phi: float = randf_range(0.0, TAU)
	
	var pos: Vector3 = Vector3(
		radius * sin(theta) * cos(phi),
		radius * cos(theta),
		radius * sin(theta) * sin(phi)
	)
	
	sprite.position = pos
	#sprite.look_at(position + pos.rotated(Vector3.UP, PI / 2.0))

func _on_timer_timeout() -> void:
	teleport_sprite()
