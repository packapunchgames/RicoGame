extends TextureButton

var state : bool = false

@export var texture_off : Texture2D
@export var texture_on : Texture2D

@onready var click_positive: AudioStreamPlayer = $ClickPositive
@onready var click_negative: AudioStreamPlayer = $ClickNegative

func _on_pressed() -> void:
	state = !state
	update_texture()
	if state:
		click_positive.play()
	else:
		click_negative.play()

func update_texture() -> void:
	match state:
		false:
			texture_normal = texture_off
			texture_pressed = texture_on
		true:
			texture_normal = texture_on
			texture_pressed = texture_off
