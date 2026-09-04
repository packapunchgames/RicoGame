extends Control

@onready var timer: Timer = $Timer

@onready var timer_progress_bar: TextureProgressBar = $TimerProgressBar
@onready var ticking: AudioStreamPlayer = $Sounds/Ticking
@onready var whoosh: AudioStreamPlayer = $Sounds/Whoosh
@onready var tap: AudioStreamPlayer = $Sounds/Tap
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_detector: TextureButton = $ClickDetector

var tween : Tween

func _ready() -> void:
	Global.show_revive_screen.connect(play_revive_animation)

func play_revive_animation() -> void:
	get_tree().paused = true
	Global.did_try_second_chance = true
	animation_player.play("transition")
	whoosh.play()
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
	exit_screen()


func exit_screen() -> void:
	animation_player.play_backwards("transition")
	whoosh.play()
	await animation_player.animation_finished
	Global.game_over.emit()


func _on_click_detector_pressed() -> void:
	click_detector.disabled = true
	tween.stop()
	ticking.stop()
	tap.play()
	timer_progress_bar.value = timer_progress_bar.max_value
	await get_tree().create_timer(0.5).timeout
	exit_screen()


func _on_ad_button_pressed() -> void:
	timer.stop()
	tween.stop()
	ticking.stop()
	animation_player.play_backwards("transition")
	whoosh.play()
	await animation_player.animation_finished
	Global.lives = 4
	Global.player.emit_signal("restart")
	get_tree().paused = false
	Global.game_resumed.emit()
	Global.player.hasStartedLevel = true

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)
