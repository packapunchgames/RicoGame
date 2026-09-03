extends Control

@export var main_scene : PackedScene
@export var home_scene : PackedScene

@onready var money_collected: Label = $MarginContainer/HBoxContainer/MoneyCollected

@onready var ticking: AudioStreamPlayer = $Audio/Ticking

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

func _on_return_to_home_pressed() -> void:
	get_tree().change_scene_to_packed(home_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		if Global.money_gained > 0:
			Resources.money += Global.money_gained
			ticking.play()
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


func animate_text(val: int) -> void:
	money_collected.text = "You collected x" + str(val)
	ticking.pitch_scale += 0.1
