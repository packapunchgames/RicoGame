extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal back

func show_self() -> void:
	animation_player.play("transition")


func _on_back_button_pressed() -> void:
	Settings.vibrate(5, 60)
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	back.emit()
