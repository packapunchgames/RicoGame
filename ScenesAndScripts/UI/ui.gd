extends Control

@onready var lives_number_display: Label = $MarginContainer/VBoxContainer/LivesDisplay/NumberDisplay
@onready var pause_screen: Control = $Overlays/PauseScreen
@onready var hints_number_display: Label = $MarginContainer/VBoxContainer/HintsButton/NumberDisplay


func _ready() -> void:
	Global.lives_changed.connect(update_lives)
	Resources.hint_used.connect(update_hints)
	update_lives()
	update_hints()

func update_lives() -> void:
	if Global.lives > 1:
		lives_number_display.text = str(Global.lives)
	elif Global.lives == 1:
		lives_number_display.hide()

func update_hints() -> void:
	hints_number_display.text = "x" + str(Resources.hints)


func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_screen.on_pause_pressed()


func _on_hints_button_pressed() -> void:
	if !Global.has_used_hint and !Global.player.hasShot:
		if Resources.hints > 0:
			Global.has_used_hint = true
			Resources.hints -= 1
			Resources.hint_used.emit()
