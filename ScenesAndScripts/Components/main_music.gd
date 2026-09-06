extends AudioStreamPlayer

@export var pitch_increment : float = 0.01
@export var max_pitch : float = 1.5
@export var fade_time : float = 1.0

var current_pitch : float = 0.9
var last_pitch : float 

var tween : Tween

func _ready() -> void:
	Global.level_succeded.connect(scale_pitch)
	Global.game_paused.connect(slow_down)
	Global.game_resumed.connect(resume)
	Global.show_revive_screen.connect(slow_down)
	Global.game_over.connect(slow_down)
	last_pitch = current_pitch

func scale_pitch() -> void:
	if !(pitch_scale + pitch_increment) > max_pitch:
		tween = create_tween()
		current_pitch = last_pitch + pitch_increment
		tween.tween_property(self, "pitch_scale", current_pitch, fade_time)
		await tween.finished
		last_pitch = current_pitch
		tween.kill()

func slow_down() -> void:
	if tween:
		tween.stop()
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "pitch_scale", 0.0001, fade_time / 2)
	await tween.finished
	stream_paused = true
	tween.kill()

func resume() -> void:
	stream_paused = false
	tween = create_tween()
	tween.tween_property(self, "pitch_scale", current_pitch, fade_time / 2)
	await tween.finished
	tween.kill()
