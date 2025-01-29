extends Interactable

@export var textures: Array[Texture2D] = []
@export var active_texture_index: int = 0:
	set(value):
		active_texture_index = value
		if active_texture_index >= 0 and active_texture_index < textures.size():
			apply_texture(textures[active_texture_index])

@export var mesh_instance: MeshInstance3D

var interact_text_override: String

func _ready() -> void:
	interact_text_override = "{0} [{1}]".format([interact_text, Global.interact_bind])
	interact_text = interact_text_override

	if textures.size() > 0 and active_texture_index < textures.size():
		apply_texture(textures[active_texture_index])

func interact(_player: CharacterBody3D) -> void:
	super(_player)
	Global.player_immobile = true
	SignalBus.display_note.emit(textures[active_texture_index])


# apply texture to the note
func apply_texture(texture: Texture2D) -> void:
	if mesh_instance and mesh_instance.mesh:
		
		var material: StandardMaterial3D
		if mesh_instance.get_surface_override_material(0) != null:
			material = mesh_instance.get_surface_override_material(0)
		else:
			material = StandardMaterial3D.new()
		
		
		material.albedo_texture = texture
		mesh_instance.set_surface_override_material(0, material)
