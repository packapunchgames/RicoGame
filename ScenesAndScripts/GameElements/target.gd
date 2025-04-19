extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_sound: AudioStreamPlayer = $HitSound

func _on_area_2d_body_entered(body: Node2D) -> void:
	Settings.vibrate(10, 90)
	hit_sound.play()
	Global.hit_stop(0.05)
	if body is Player:
		body.speed += body.boost
	animation_player.play("dead")
	await animation_player.animation_finished
	create_texture()
	queue_free()

func create_texture() -> void:
	var texture : Sprite2D = Sprite2D.new()
	texture.texture = sprite_2d.texture
	texture.scale = sprite_2d.scale
	texture.modulate = modulate
	texture.global_position = global_position
	get_parent().add_child(texture)
