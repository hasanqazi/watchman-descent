extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@export var speed: float = 3.0
@export var life_time: float = 10.0

func _physics_process(delta: float) -> void:
	var current_location: Vector3 = global_transform.origin
	var next_location: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_location - current_location).normalized() * speed
	
	life_time = life_time - delta
	
	if life_time < 0:
		print("Maze Enemy despawned")
		queue_free()
	
	velocity = velocity.move_toward(new_velocity, 0.3)
	move_and_slide()

func update_target_location(target_location: Vector3) -> void:
	nav_agent.target_position = target_location


func _on_navigation_agent_3d_target_reached() -> void:
	print("Player killed")
