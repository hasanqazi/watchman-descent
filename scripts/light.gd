extends Node3D

@onready var spotlight: SpotLight3D = $SpotLight3D
@onready var light: MeshInstance3D = $Cube

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spotlight.light_color = Color("f5e099")
	var mat := light.get_active_material(1)
	if mat:
		mat.albedo_color = Color("f5e099")
	SignalBus.light_change.connect(mirror_light_toggle)


func mirror_light_toggle() -> void:
	spotlight.light_color = Color("f53900")
	var mat := light.get_active_material(1)
	if mat:
		mat.albedo_color = Color("f53900")
