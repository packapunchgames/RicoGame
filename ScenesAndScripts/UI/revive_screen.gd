extends Control

@onready var timer: Timer = $Timer

@onready var timer_progress_bar: TextureProgressBar = $TimerProgressBar
@onready var ticking: AudioStreamPlayer = $Sounds/Ticking
@onready var whoosh: AudioStreamPlayer = $Sounds/Whoosh
@onready var tap: AudioStreamPlayer = $Sounds/Tap
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_detector: TextureButton = $ClickDetector
@onready var ad_button: TextureButton = $TimerProgressBar/MarginContainer2/AdButton

var tween : Tween

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()
var is_loaded := false:
	set(x):
		is_loaded = x
		ad_button.disabled = !x

func _ready() -> void:
	Global.show_revive_screen.connect(play_revive_animation)
	
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		destroy()
	
	_load_ad()

func _load_ad() -> void:
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	print("loading ad")
	RewardedAdLoader.new().load("ca-app-pub-3940256099942544/5224354917", AdRequest.new(), rewarded_ad_load_callback)

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print("ad failed")
	is_loaded = false

func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("ad loaded")
	rewarded_ad.full_screen_content_callback = full_screen_content_callback
	is_loaded = true
	self.rewarded_ad = rewarded_ad

func _show_ad() -> void:
	print("showing ad")
	timer.stop()
	tween.stop()
	ticking.stream_paused = true
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		is_loaded = false

func on_user_earned_reward(rewarded_item : RewardedItem) -> void:
	print("reward")
	animation_player.play_backwards("transition")
	whoosh.play()
	await animation_player.animation_finished
	Global.lives = 4
	Global.player.emit_signal("restart")
	get_tree().paused = false
	Global.game_resumed.emit()
	Global.player.hasStartedLevel = true

func destroy() -> void:
	print("destroying ad")
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null

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
	_show_ad()

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)

func _exit_tree() -> void:
	destroy()
