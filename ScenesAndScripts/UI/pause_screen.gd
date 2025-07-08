extends Control

@onready var settings: Control = $MarginContainer/Container/CuttingBoard/MarginContainer/Overlays/Settings
@onready var main_menu: VBoxContainer = $MarginContainer/Container/CuttingBoard/MarginContainer/MainMenu

func _on_continue_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_settings_pressed() -> void:
	main_menu.hide()
	settings.show_self()


func _on_settings_back() -> void:
	main_menu.show()
