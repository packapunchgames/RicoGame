extends AudioStreamPlayer

@export var pitch_increment : float = 0.01
@export var max_pitch : float = 1.5
@export var fade_time : float = 1.0

var current_pitch : float = 0.9

func _ready() -> void:
	Global.level_succeded.connect(scale_pitch)
	Global.game_paused.connect(slow_down)
	Global.game_resumed.connect(resume)
	Global.show_revive_screen.connect(slow_down)
	Global.game_over.connect(slow_down)

func scale_pitch() -> void:
	if !(pitch_scale + pitch_increment) > max_pitch:
		var tween : Tween = create_tween()
		tween.tween_property(self, "pitch_scale", pitch_scale + pitch_increment, fade_time)
		current_pitch = pitch_scale

func slow_down() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "pitch_scale", 0.0001, fade_time / 2)
	await tween.finished
	stream_paused = true

func resume() -> void:
	stream_paused = false
	var tween : Tween = create_tween()
	tween.tween_property(self, "pitch_scale", current_pitch, fade_time / 2)
