extends Node
class_name Overlay

@onready var vignette: ColorRect = $Vignette
@onready var flash: ColorRect = $Flash

@export var vignette_intensity : int = 2

func _ready() -> void:
	flash.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.overlay = self

func _process(delta: float) -> void:
	if Global.player.hasStarted:
		vignette.material.set_shader_parameter("vignette_intensity", Global.player.force / (vignette_intensity * 1000))
	else:
		vignette.material.set_shader_parameter("vignette_intensity", 0)

func hit_flash(duration : float) -> void:
	var tween :Tween = create_tween()
	tween.tween_property(flash, "self_modulate",Color(1.0, 1.0, 1.0), duration / 2).set_ease(Tween.EASE_OUT)
	tween.tween_property(flash, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), duration / 2).set_ease(Tween.EASE_IN)
