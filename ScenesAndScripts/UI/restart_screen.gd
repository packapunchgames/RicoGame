extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui_click_positive: AudioStreamPlayer = $UIClickPositive

signal back

func show_self() -> void:
	animation_player.play("show")

func _on_no_pressed() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	back.emit()

func _on_yes_pressed() -> void:
	ui_click_positive.play()
	Global.did_game_restart = true
	Global.restart.emit()
	Settings.vibrate(5, 60)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if visible:
			_on_no_pressed()
