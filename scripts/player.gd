extends CharacterBody3D

@onready var head: Node3D = %Head
@onready var footstep_player: AudioStreamPlayer3D = %Footsteps

var current_speed: float = 5.0

@export var walking_speed: float = 5.0
@export var sprinting_speed: float = 8.0

const JUMP_VELOCITY: float = 4.5

@export var mouse_sensitivity: float = 0.08
@export var head_clamp: int = 79

var lerp_speed: float = 10.0

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Global.player_immobile == false:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-head_clamp), deg_to_rad(head_clamp))

func _physics_process(delta: float) -> void:
	if Global.player_immobile == true:
		return
	
	# Handle speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)

	# Apply velocity
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)


	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and horizontal_speed > 0.1:
		if not footstep_player.playing:
			footstep_player.play()
		footstep_player.pitch_scale = 1.5 if current_speed == sprinting_speed else 1.0
	else:
		footstep_player.stop()

	move_and_slide()
