extends Control

@onready var hints_button: TextureButton = $MarginContainer/VBoxContainer/HintsButton
@onready var lives_number_display: Label = $MarginContainer/VBoxContainer/LivesDisplay/NumberDisplay
@onready var pause_screen: Control = $Overlays/PauseScreen
@onready var hints_number_display: Label = $MarginContainer/VBoxContainer/HintsButton/NumberDisplay
@onready var ad_icon: TextureRect = $MarginContainer/VBoxContainer/HintsButton/AdIcon
@onready var animation_player: AnimationPlayer = $MarginContainer/AdFailed/AnimationPlayer


var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()
var is_loaded := false:
	set(x):
		is_loaded = x
		hints_button.disabled = !x
		if is_loaded:
			ad_icon.modulate = Color.WHITE
		else:
			ad_icon.modulate = Color.DIM_GRAY

func _ready() -> void:
	Global.lives_changed.connect(update_lives)
	Resources.hint_used.connect(update_hints)
	update_lives()
	update_hints()
	
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		destroy()
		_load_ad()
	
	_load_ad()

func _load_ad() -> void:
	print("loading ad")
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	
	RewardedAdLoader.new().load("ca-app-pub-3940256099942544/5224354917", AdRequest.new(), rewarded_ad_load_callback)

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print("ad failed")
	is_loaded = false
	animation_player.play("ad_fail")

func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("ad loaded")
	rewarded_ad.full_screen_content_callback = full_screen_content_callback
	is_loaded = true
	self.rewarded_ad = rewarded_ad

func _show_ad() -> void:
	print("showing ad")
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		is_loaded = false

func on_user_earned_reward(rewarded_item : RewardedItem) -> void:
	print("reward")
	Resources.hints += 1
	update_hints()

func destroy() -> void:
	print("destroying ad")
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null


func update_lives() -> void:
	if Global.lives > 1:
		lives_number_display.show()
		lives_number_display.text = str(Global.lives)
	elif Global.lives == 1:
		lives_number_display.hide()

func update_hints() -> void:
	if Resources.hints > 0:
		ad_icon.hide()
		hints_number_display.show()
		hints_number_display.text = "x" + str(Resources.hints)
	else:
		ad_icon.show()
		hints_number_display.hide()


func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_screen.on_pause_pressed()


func _on_hints_button_pressed() -> void:
	Settings.vibrate(5, 80)
	if !Global.has_used_hint and !Global.player.hasShot:
		if Resources.hints > 0:
			Global.has_used_hint = true
			Resources.hints -= 1
			SaveLoad.data.hints = Resources.hints
			Resources.hint_used.emit()
		else:
			_show_ad()

func _exit_tree() -> void:
	destroy()
