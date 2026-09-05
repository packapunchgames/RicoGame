extends ColorRect

var loaded_scene : PackedScene

func _enter_tree() -> void:
	if Resources.is_first_run:
		loaded_scene = load("res://ScenesAndScripts/UI/tutorial.tscn")
	else:
		loaded_scene = load("res://ScenesAndScripts/UI/StartScreen.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(loaded_scene)
