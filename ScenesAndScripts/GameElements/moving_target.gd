@tool
extends CharacterBody2D

'''
Problems:
	1. Not displaying path properly
	2. Restart problems
	3. Not dying
	4. Not looping properly
'''

@export var speed : int = 10
@export var start_position : Vector2:
	set(a):
		start_position = a
@export var end_position : Vector2:
	set(b):
		end_position = b

@export_range(0.0, 1.0) var progress : float = 0.0:
	set(x):
		progress = clampf(x, 0.0, 1.0)
		update_position()

enum DIRECTION {FIRST, SECOND}
@export var dir : DIRECTION = DIRECTION.SECOND

func update_position() -> void:
	position = start_position.lerp(end_position, progress)

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		match dir:
			DIRECTION.FIRST:
				position.x = move_toward(position.x, start_position.x, speed)
				position.y = move_toward(position.y, start_position.y, speed)
				if position == start_position:
					dir = DIRECTION.SECOND
			DIRECTION.SECOND:
				position.x = move_toward(position.x, end_position.x, speed)
				position.y = move_toward(position.y, end_position.y, speed)
				if position == end_position:
					dir = DIRECTION.FIRST

func _on_area_2d_body_entered(body: Node2D) -> void:
	Input.vibrate_handheld(10)
	Global.hit_stop(0.05)
	if body is Ball:
		body.speed += body.boost
	queue_free()
