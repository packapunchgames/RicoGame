extends ColorRect

@export var intensity := 2

func _process(delta: float) -> void:
	if Global.player.hasStarted:
		material.set_shader_parameter("vignette_intensity", Global.player.force / (intensity * 1000))
	else:
		material.set_shader_parameter("vignette_intensity", 0)
