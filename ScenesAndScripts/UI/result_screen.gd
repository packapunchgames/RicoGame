extends Control

@export var main_scene : PackedScene
@export var home_scene : PackedScene

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

func _on_return_to_home_pressed() -> void:
	get_tree().change_scene_to_packed(home_scene)
