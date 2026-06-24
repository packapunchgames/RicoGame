extends Control

@onready var settings: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/Settings
@onready var restart_screen: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/RestartScreen
@onready var return_to_home_screen: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/ReturnToHomeScreen

@onready var main_menu: VBoxContainer = $MarginContainer/Container/CuttingBoard/MarginContainer/MainMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var click_positive: AudioStreamPlayer = $Sounds/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Sounds/ClickNegative


func on_pause_pressed() -> void:
	animation_player.play("show")
	click_positive.play()
	Settings.vibrate(5, 20)
	Global.game_paused.emit()
	

func _on_continue_pressed() -> void:
	get_tree().paused = false
	click_negative.play()
	animation_player.play_backwards("show")
	Settings.vibrate(5, 20)
	Global.game_resumed.emit()
	

func _on_settings_pressed() -> void:
	animation_player.play_backwards("main_menu")
	click_positive.play()
	settings.show_self()
	Settings.vibrate(5, 20)

func _on_restart_pressed() -> void:
	animation_player.play_backwards("main_menu")
	click_positive.play()
	restart_screen.show_self()
	Settings.vibrate(5, 20)

func _on_home_pressed() -> void:
	animation_player.play_backwards("main_menu")
	click_positive.play()
	return_to_home_screen.show_self()
	Settings.vibrate(5, 20)

func _on_back() -> void:
	click_negative.play()
	animation_player.play("main_menu")
	Settings.vibrate(5, 20)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)
