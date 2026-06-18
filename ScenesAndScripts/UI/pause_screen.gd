extends Control

@onready var settings: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/Settings
@onready var restart_screen: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/RestartScreen
@onready var return_to_home_screen: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/ReturnToHomeScreen


@onready var main_menu: VBoxContainer = $MarginContainer/Container/CuttingBoard/MarginContainer/MainMenu
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_pause_pressed() -> void:
	animation_player.play("show")
	Global.game_paused.emit()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	animation_player.play_backwards("show")
	Global.game_resumed.emit()

func _on_settings_pressed() -> void:
	animation_player.play_backwards("main_menu")
	settings.show_self()

func _on_restart_pressed() -> void:
	animation_player.play_backwards("main_menu")
	restart_screen.show_self()

func _on_home_pressed() -> void:
	animation_player.play_backwards("main_menu")
	return_to_home_screen.show_self()

func _on_back() -> void:
	animation_player.play("main_menu")
