extends Control

var main_scene : PackedScene
var home_scene : PackedScene

@onready var settings: Control = $Overlay/Settings

@onready var money_collected: Label = $MarginContainer/HBoxContainer/MoneyCollected
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ticking: AudioStreamPlayer = $Audio/Ticking
@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative

var max_pitch : float
var min_pitch : float = 0.75

func _ready() -> void:
	main_scene = load("res://ScenesAndScripts/Components/main.tscn")
	home_scene = load("res://ScenesAndScripts/UI/StartScreen.tscn")

func _on_play_again_pressed() -> void:
	animation_player.play_backwards("fade")
	click_positive.play()
	Settings.vibrate(5, 60)
	await animation_player.animation_finished
	SaveLoad.save_data()
	get_tree().change_scene_to_packed(main_scene)

func _on_return_to_home_pressed() -> void:
	animation_player.play_backwards("fade")
	click_positive.play()
	Settings.vibrate(5, 60)
	await animation_player.animation_finished
	SaveLoad.save_data()
	get_tree().change_scene_to_packed(home_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		if Global.money_gained > 0:
			Resources.money += Global.money_gained
			SaveLoad.data.money = Resources.money
			ticking.play()
			max_pitch = clampf(Global.money_gained / 10.0, 2.0, 6.0)
			var tween : Tween = create_tween()
			tween.tween_method(
			animate_text,
			0,
			Global.money_gained,
			2
			).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			await tween.finished
			ticking.stop()
			Global.money_gained = 0
			Global.potential_kills = 0


func animate_text(val: int) -> void:
	money_collected.text = "You collected x" + str(val)
	var progress := float(val) / float(Global.money_gained)
	ticking.pitch_scale = lerp(max_pitch, min_pitch, progress)


func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)


func _on_change_settings_pressed() -> void:
	animation_player.play("main_menu_fade")
	click_positive.play()
	Settings.vibrate(5, 60)
	settings.show_self()


func _on_settings_back() -> void:
	click_negative.play()
	Settings.vibrate(5, 60)
	animation_player.play_backwards("main_menu_fade")
