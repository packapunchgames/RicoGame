extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative


@onready var increase_lives: Button = $MarginContainer/HBoxContainer/LivesShop/IncreaseLives
@onready var price_display: Label = $MarginContainer/HBoxContainer/LivesShop/VBoxContainer/PriceDisplay
@onready var money_display: Label = $MarginContainer/HBoxContainer/LivesShop/PanelContainer/HBoxContainer/MoneyDisplay
@onready var lives_display: Label = $MarginContainer/HBoxContainer/LivesShop/VBoxContainer/LivesIcon/LivesDisplay
@onready var hints_display: Label = $MarginContainer/HBoxContainer/HintsShop/VBoxContainer/HintsIcon/HintsDisplay

var price : int
var money_tween : Tween

@onready var increase_hints: TextureButton = $MarginContainer/HBoxContainer/HintsShop/IncreaseHints

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()
var is_loaded := false:
	set(x):
		is_loaded = x
		increase_hints.disabled = !x

func _ready() -> void:
	MobileAds.initialize()
	
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		destroy()
		_load_ad()
	
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
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		is_loaded = false

func on_user_earned_reward(rewarded_item : RewardedItem) -> void:
	print("reward")
	Resources.hints += 1
	SaveLoad.data.hints = Resources.hints
	SaveLoad.save_cloud_data()
	update_data()

func destroy() -> void:
	print("destroying ad")
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null

func show_self() -> void:
	update_data()
	animation_player.play("transition")

func update_data() -> void:
	price = Resources.max_lives * 100
	increase_lives.disabled = Resources.money < price
	money_display.text = str(Resources.money)
	price_display.text = "PRICE: " + str(price)
	lives_display.text = str(Resources.max_lives)
	hints_display.text = "x" + str(Resources.hints)

func _on_increase_lives_pressed() -> void:
	var start_money := Resources.money
	
	Resources.max_lives += 1
	Resources.money -= price
	SaveLoad.data.max_lives = Resources.max_lives
	SaveLoad.data.money = Resources.money
	SaveLoad.save_cloud_data()
	update_data()
	
	click_positive.play()
	Settings.vibrate(5, 80)
	if money_tween and money_tween.is_running():
		money_tween.kill()

	money_tween = create_tween()
	money_tween.tween_method(
		func(val: int) -> void: money_display.text = str(val),
		start_money,
		Resources.money,
		0.5
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_back_button_pressed() -> void:
	animation_player.play_backwards("transition")
	click_negative.play()
	Settings.vibrate(5, 80)


func _on_increase_lives_button_down() -> void:
	Settings.vibrate(5, 40)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if visible:
			_on_back_button_pressed()


func _on_increase_hints_pressed() -> void:
	click_positive.play()
	Settings.vibrate(5, 80)
	_show_ad()
