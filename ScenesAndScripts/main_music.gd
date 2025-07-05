extends AudioStreamPlayer

@export var pitch_increment : float = 0.01
@export var max_pitch : float = 1.5
@export var fade_time : float = 1.0

func _ready() -> void:
	Global.level_succeded.connect(scale_pitch)

func scale_pitch() -> void:
	if !(pitch_scale + pitch_increment) > max_pitch:
		var tween : Tween = create_tween()
		tween.tween_property(self, "pitch_scale", pitch_scale + pitch_increment, fade_time)
