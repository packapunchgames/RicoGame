extends Control

@onready var number_display: Label = $MarginContainer/VBoxContainer/LivesDisplay/NumberDisplay
@onready var settings: Control = $Overlays/Settings

func _process(delta: float) -> void:
	number_display.text = str(Global.lives)


func _on_pause_pressed() -> void:
	get_tree().paused = !get_tree().paused
	settings.show_self()


func _on_hints_button_pressed() -> void:
	if !Global.has_used_hint and !Global.player.hasShot:
		if Resources.hints > 0:
			Global.has_used_hint = true
			Resources.hints -= 1
			Resources.hint_used.emit()
