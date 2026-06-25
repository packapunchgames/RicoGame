extends TextureButton

var state : bool = false

@export var texture_off : Texture2D
@export var texture_on : Texture2D

func _on_pressed() -> void:
	state = !state
	update_texture()

func update_texture() -> void:
	match state:
		false:
			texture_normal = texture_off
			texture_pressed = texture_on
		true:
			texture_normal = texture_on
			texture_pressed = texture_off
