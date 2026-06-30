extends Control

@onready var lives_number_display: Label = $MarginContainer/VBoxContainer/LivesDisplay/NumberDisplay
@onready var pause_screen: Control = $Overlays/PauseScreen
@onready var hints_number_display: Label = $MarginContainer/VBoxContainer/HintsButton/NumberDisplay
@onready var ad_icon: TextureRect = $MarginContainer/VBoxContainer/HintsButton/AdIcon
@onready var animation_player: AnimationPlayer = $MarginContainer/AdFailed/AnimationPlayer


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
	if Resources.hints > 0:
		ad_icon.hide()
		hints_number_display.show()
		hints_number_display.text = "x" + str(Resources.hints)
	else:
		ad_icon.show()
		hints_number_display.hide()


func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_screen.on_pause_pressed()


func _on_hints_button_pressed() -> void:
	if !Global.has_used_hint and !Global.player.hasShot:
		if Resources.hints > 0:
			Global.has_used_hint = true
			Resources.hints -= 1
			Resources.hint_used.emit()
		else:
			animation_player.play("ad_fail")
