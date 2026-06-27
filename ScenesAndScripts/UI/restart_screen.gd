extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal back

func show_self() -> void:
	animation_player.play("show")

func _on_no_pressed() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	back.emit()

func _on_yes_pressed() -> void:
	Global.did_game_restart = true
	Global.restart.emit()
	Settings.vibrate(5, 20)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)
