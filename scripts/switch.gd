extends Interactable

@export var switched: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func interact(player: CharacterBody3D) -> void:
	super(player)
	switched = true
	interact_text = ""
	SignalBus.interact_text.emit(interact_text)
	interactable = false
	anim_player.play("Switched")
	print(player, "turned on a switch")
	
