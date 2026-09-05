extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative


@onready var increase_lives: Button = $MarginContainer/MarginContainer/IncreaseLives
@onready var price_display: Label = $MarginContainer/MarginContainer/VBoxContainer/PriceDisplay
@onready var money_display: Label = $MarginContainer/MarginContainer/PanelContainer/HBoxContainer/MoneyDisplay
@onready var lives_display: Label = $MarginContainer/MarginContainer/VBoxContainer/LivesIcon/LivesDisplay

var price : int

var money_tween : Tween

func show_self() -> void:
	update_data()
	animation_player.play("transition")

func update_data() -> void:
	price = Resources.max_lives * 100
	increase_lives.disabled = Resources.money < price
	money_display.text = str(Resources.money)
	price_display.text = "PRICE: " + str(price)
	lives_display.text = str(Resources.max_lives)

func _on_increase_lives_pressed() -> void:
	var start_money := Resources.money
	
	Resources.max_lives += 1
	Resources.money -= price
	SaveLoad.data.max_lives = Resources.max_lives
	SaveLoad.data.money = Resources.money
	SaveLoad.save_data()
	update_data()
	
	click_positive.play()
	Settings.vibrate(5, 60)
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
	Settings.vibrate(5, 60)


func _on_increase_lives_button_down() -> void:
	Settings.vibrate(5, 40)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if visible:
			_on_back_button_pressed()
