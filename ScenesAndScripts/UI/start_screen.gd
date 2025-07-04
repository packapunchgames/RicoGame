extends Control

@export var game_scene : PackedScene


func _on_game_starter_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
