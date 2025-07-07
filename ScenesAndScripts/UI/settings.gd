extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var master: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Master
@onready var music: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Music
@onready var sfx: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/SFX
@onready var vibration: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/System/GridContainer/VBoxContainer2/Vibration
@onready var sensitivity: HSlider = $MarginContainer/ScrollContainer/VBoxContainer/Game/GridContainer/VBoxContainer2/Sensitivity

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


func _on_vibration_value_changed(value: float) -> void:
	Settings.vibration = value

func _on_sensitivity_value_changed(value: float) -> void:
	Settings.sensitivity = -value


func _on_back_button_pressed() -> void:
	animation_player.play("hide")
