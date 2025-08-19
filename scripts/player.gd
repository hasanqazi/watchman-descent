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

@onready var player_cam: Camera3D = %PlayerCam
@onready var respawn_button: TextureButton = %Respawn


@export var bob_amp_walk: float = 0.05      # vertical amplitude when walking
@export var bob_amp_sprint: float = 0.08    # vertical amplitude when sprinting
@export var bob_freq_walk: float = 8.0      # steps/sec feel when walking
@export var bob_freq_sprint: float = 11.0   # steps/sec feel when sprinting
@export var bob_side_ratio: float = 0.5     # sideways sway relative to vertical
@export var bob_start_threshold: float = 0.1  # min horizontal speed to start bob

var _bob_t: float = 0.0
var _cam_base_pos: Vector3

func _ready() -> void:
	respawn_button.visible = false
	_cam_base_pos = player_cam.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Global.player_immobile == false:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-head_clamp), deg_to_rad(head_clamp))

func _physics_process(delta: float) -> void:
	if Global.player_immobile == true:
		footstep_player.stop()
		_reset_camera(delta)
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

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and horizontal_speed > bob_start_threshold:
		if not footstep_player.playing:
			footstep_player.play()
		footstep_player.pitch_scale = 1.5 if current_speed == sprinting_speed else 1.0
		_apply_camera_bob(delta, horizontal_speed)
	else:
		footstep_player.stop()
		_reset_camera(delta)

	move_and_slide()

func _apply_camera_bob(delta: float, horizontal_speed: float) -> void:
	var freq := bob_freq_sprint if current_speed == sprinting_speed else bob_freq_walk
	var amp := bob_amp_sprint if current_speed == sprinting_speed else bob_amp_walk
	
	var speed_factor: float = clamp(horizontal_speed / max(0.001, current_speed), 0.0, 1.25)
	_bob_t += delta * freq * speed_factor

	var phase := _bob_t * (2.0 * PI)

	var y_off := sin(phase) * amp
	var x_off := cos(phase * 0.5) * amp * bob_side_ratio * 0.5

	player_cam.position = _cam_base_pos + Vector3(x_off, y_off, 0.0)

func _reset_camera(delta: float) -> void:
	player_cam.position = player_cam.position.lerp(_cam_base_pos, min(1.0, delta * 10.0))
	_bob_t = lerp(_bob_t, 0.0, delta * 5.0)
