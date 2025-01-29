extends TextureRect


func _ready() -> void:
	SignalBus.display_note.connect(display_note)
	
	visible = false

func display_note(note_texture: Texture2D) -> void:
	texture = note_texture
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true


func _on_close_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player_immobile = false
	visible = false
