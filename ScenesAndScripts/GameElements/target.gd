extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hit_sound: AudioStreamPlayer = $HitSound

var preloaded_sprite_frames : Array[SpriteFrames] = [
	preload("res://Art/PNG Files/characters/Carrot/carrot_frames.tres"),
]

func _ready() -> void:
	sprite_2d.sprite_frames = preloaded_sprite_frames.pick_random()
	rotation_degrees = randi_range(0,360)


func _on_area_2d_body_entered(body: Node2D) -> void:
	Settings.vibrate(10, 90)
	hit_sound.play()
	Global.hit_stop(0.05)
	if body is Player:
		body.speed += body.boost
	animation_player.play("dead")
	var stain : AnimatedSprite2D = create_stain()
	await animation_player.animation_finished
	stain.modulate = modulate
	create_texture()
	queue_free()

func create_texture() -> void:
	var texture : AnimatedSprite2D = AnimatedSprite2D.new()
	texture.sprite_frames = sprite_2d.sprite_frames
	texture.play("cut")
	texture.scale = sprite_2d.scale
	texture.modulate = modulate
	texture.rotation_degrees = rotation_degrees
	texture.global_position = global_position
	get_parent().add_child(texture)

func create_stain() -> AnimatedSprite2D:
	var texture : AnimatedSprite2D = AnimatedSprite2D.new()
	texture.sprite_frames = sprite_2d.sprite_frames
	texture.play("stain")
	texture.modulate = modulate
	texture.scale = sprite_2d.scale
	texture.global_position = global_position
	texture.rotation_degrees = rotation_degrees
	texture.z_index = z_index - 1
	get_parent().add_child(texture)
	return texture
