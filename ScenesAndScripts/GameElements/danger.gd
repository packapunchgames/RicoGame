extends CharacterBody2D

@onready var sound: AudioStreamPlayer = $Sound

func _ready() -> void:
	Global.game_paused.connect(slow_down)
	Global.game_resumed.connect(resume)
	Global.show_revive_screen.connect(slow_down)
	Global.game_over.connect(slow_down)


func slow_down() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(sound, "pitch_scale", 0.0001, 0.5)
	await tween.finished
	sound.stream_paused = true

func resume() -> void:
	sound.stream_paused = false
	var tween : Tween = create_tween()
	tween.tween_property(sound, "pitch_scale", 1, 0.5)
