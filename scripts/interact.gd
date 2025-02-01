extends RayCast3D

var interact_timer: float

@onready var texture_progress: TextureProgressBar = %InteractProgress


func _ready() -> void:
	texture_progress.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider and collider.owner.interactable == true:
			var object = get_collider().owner
			object.display_interact_text()
		
			if Input.is_action_pressed("interact"):
				if interact_timer <= 0:
					interact_timer = object.interact_cooldown
					texture_progress.value = 0
					texture_progress.visible = true
				
				interact_timer -= delta
				texture_progress.value = (1 - interact_timer / object.interact_cooldown) * 100
				
				if interact_timer <= 0:
					object.interact(owner)
					texture_progress.value = 0
					texture_progress.visible = false
			else:
				interact_timer = 0
				texture_progress.value = 0
				texture_progress.visible = false
	else:
		SignalBus.interact_text.emit("")
		texture_progress.value = 0
