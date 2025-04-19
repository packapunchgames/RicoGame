@tool
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sound: AudioStreamPlayer = $HitSound

@export var speed : float = 1
@export var start_position : Vector2:
	set(a):
		start_position = a
		update_position()
@export var end_position : Vector2:
	set(b):
		end_position = b
		update_position()
@export_range(0.0, 1.0) var progress : float = 0.0:
	set(x):
		progress = clampf(x, 0.0, 1.0)
		update_position()

enum DIRECTION {FIRST, SECOND}
@export var dir : DIRECTION = DIRECTION.SECOND

func update_position() -> void:
	position = start_position.lerp(end_position, progress)
	if Engine.is_editor_hint():
		queue_redraw()

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		update_position()
		match dir:
			DIRECTION.FIRST:
				progress = move_toward(progress, 1.0, speed * delta)
				if progress == 1.0:
					dir = DIRECTION.SECOND
			DIRECTION.SECOND:
				progress = move_toward(progress, 0.0, speed * delta)
				if progress == 0.0:
					dir = DIRECTION.FIRST

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

func _draw() -> void:
	if Engine.is_editor_hint():
		var local_start := to_local(start_position)
		var local_end := to_local(end_position)
		draw_line(local_start, local_end, Color.RED, 2.0)
		draw_circle(local_start, 50, Color.GREEN)
		draw_circle(local_end, 50, Color.BLUE)

func create_texture() -> void:
	var texture : Sprite2D = Sprite2D.new()
	texture.texture = sprite_2d.texture
	texture.scale = sprite_2d.scale
	texture.modulate = modulate
	texture.global_position = global_position
	get_parent().add_child(texture)
