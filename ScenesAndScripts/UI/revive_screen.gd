extends Control

@export_range(0,10) var timer : float

@onready var timer_progress_bar: TextureProgressBar = $TimerProgressBar
@onready var ticking: AudioStreamPlayer = $Sounds/Ticking
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Global.show_revive_screen.connect(play_revive_animation)

func play_revive_animation() -> void:
	get_tree().paused = true
	Global.did_try_second_chance = true
	animation_player.play("intro")

func start_ticking() -> void:
	var tween := create_tween()
	ticking.play()
	tween.tween_property(timer_progress_bar, "value", 100, timer)
	await tween.finished
	ticking.stop()
