extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var master: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Master
@onready var music: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Music
@onready var sfx: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/SFX
@onready var vibration: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Vibration
@onready var sensitivity: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/Game/GridContainer/VBoxContainer2/Sensitivity
@onready var visual_effects: TextureButton = $MarginContainer/ScrollContainer/VBoxContainer/Game/GridContainer/VBoxContainer2/VisualEffects

var has_updated_settings : bool = false
@onready var click: AudioStreamPlayer = $Sounds/Click

signal back

func _ready() -> void:
	update_settings()

func show_self() -> void:
	update_settings()
	animation_player.play("show")

func update_settings() -> void:
	master.value = Settings.master_volume
	music.value = Settings.music
	sfx.value = Settings.sfx
	vibration.value = Settings.vibration
	sensitivity.value = -Settings.sensitivity
	
	visual_effects.state = Settings.visual_effects
	visual_effects.update_texture()
	
	has_updated_settings = true

func _on_vibration_value_changed(value: float) -> void:
	Settings.vibration = value

func _on_sensitivity_value_changed(value: float) -> void:
	Settings.sensitivity = -value

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	back.emit()

func slider_value_changed(value: float) -> void:
	if has_updated_settings:
		click.play()
		Settings.vibrate(5, 50)

func _on_visual_effects_pressed() -> void:
	Settings.visual_effects = visual_effects.state
