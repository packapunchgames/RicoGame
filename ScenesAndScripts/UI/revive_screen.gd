extends Control

@onready var timer: Timer = $Timer

@onready var timer_progress_bar: TextureProgressBar = $TimerProgressBar
@onready var ticking: AudioStreamPlayer = $Sounds/Ticking
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tween : Tween

func _ready() -> void:
	Global.show_revive_screen.connect(play_revive_animation)

func play_revive_animation() -> void:
	get_tree().paused = true
	Global.did_try_second_chance = true
	animation_player.play("transition")
	await animation_player.animation_finished
	start_ticking()

func start_ticking() -> void:
	tween = create_tween()
	ticking.play()
	timer.start()
	tween.tween_property(timer_progress_bar, "value", 100, timer.wait_time)

func _on_timer_timeout() -> void:
	tween.stop()
	ticking.stop()
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	Global.game_over.emit()
