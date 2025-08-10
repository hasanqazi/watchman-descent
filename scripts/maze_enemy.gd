extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_player: AnimationPlayer = $stalker_anim/AnimationPlayer

@export var speed: float = 3.0
@export var life_time: float = 10.0
@export var immobile: bool = false

func _physics_process(delta: float) -> void:
	if Global.player_immobile == true:
		return
	var current_location: Vector3 = global_transform.origin
	var next_location: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_location - current_location).normalized() * speed
	
	look_at(next_location)

	life_time -= delta
	if life_time < 0:
		print("Maze Enemy despawned")
		queue_free()
	
	if !immobile and Global.flashlight_powered:
		anim_player.speed_scale = 2.0
		anim_player.play("Running")
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()
	else:
		anim_player.speed_scale = 1.0
		anim_player.play("Looking")


func update_target_location(target_location: Vector3) -> void:
	nav_agent.target_position = target_location


func _on_navigation_agent_3d_target_reached() -> void:
	SignalBus.player_respawn.emit()
	
	queue_free()
	print("Player killed")
