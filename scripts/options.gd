extends Control

@onready var background: ColorRect = $ColorRect
@onready var volume_slider: HSlider = $VolumeSlider
@onready var fullscreen: CheckBox = $FullscreenToggle

@export var button_sound: AudioStream

var mouse_toggled: bool = false

func _ready() -> void:
	SignalBus.toggle_options.connect(_on_toggle_options)
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen.button_pressed = true
	
	volume_slider.value = Global.volume_value
	AudioServer.set_bus_volume_db(0, linear_to_db(volume_slider.value / 100.0))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_toggle_options(!visible)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value: float) -> void:
	Global.volume_value = value
	
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_toggle_options(toggle: bool) -> void:
	visible = toggle
	
	if toggle == true:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Global.player_immobile = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_toggled = true
	
	if toggle == false:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE and mouse_toggled == true:
			Global.player_immobile = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_toggled = false
	


func _on_close_pressed() -> void:
	SignalBus.play_options_audio.emit(button_sound)
	_on_toggle_options(false)
