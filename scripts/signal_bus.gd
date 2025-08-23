extends Node


signal interact_text(text: String)
signal play_interact_audio(audio: AudioStream)
signal add_item_to_inv(item: Node3D)
signal display_note(note_texture: Texture2D)
signal changed_level(level: Global.Levels)
signal unlock_door(id: int)
signal lever_switched()
signal show_dialogue(dialogue: String)
signal light_change()
signal player_respawn()
signal open_gate()
signal toggle_sprite()
