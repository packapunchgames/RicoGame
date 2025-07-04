extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSound
var dead : bool = false

@onready var food_sprite: AnimatedSprite2D = $Sprite2D
var preselected_frames : SpriteFrames

var preloaded_sprite_frames : Array[SpriteFrames] = [
	preload("res://Art/PNG Files/characters/Carrot/carrot_frames.tres"),
	preload("res://Art/PNG Files/characters/Onion/onion_frames.tres"),
	preload("res://Art/PNG Files/characters/Pepper/red_pepper_frames.tres"),
	preload("res://Art/PNG Files/characters/Pepper/green_pepper_frames.tres"),
	preload("res://Art/PNG Files/characters/Zucchini/zucchini_frames.tres")
]

func _ready() -> void:
	if preselected_frames:
		food_sprite.sprite_frames = preselected_frames
	else:
		food_sprite.sprite_frames = preloaded_sprite_frames.pick_random()
	rotation_degrees = randi_range(0,360)


func _on_area_2d_body_entered(body: Node2D) -> void:
	dead = true
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
	texture.sprite_frames = food_sprite.sprite_frames
	texture.play("cut")
	texture.scale = food_sprite.scale
	texture.modulate = modulate
	texture.rotation_degrees = rotation_degrees
	texture.global_position = global_position
	get_parent().add_child(texture)

func create_stain() -> AnimatedSprite2D:
	var texture : AnimatedSprite2D = AnimatedSprite2D.new()
	texture.sprite_frames = food_sprite.sprite_frames
	texture.play("stain")
	texture.modulate = modulate
	texture.scale = food_sprite.scale
	texture.global_position = global_position
	texture.rotation_degrees = rotation_degrees
	texture.z_index = z_index - 1
	get_parent().add_child(texture)
	return texture
