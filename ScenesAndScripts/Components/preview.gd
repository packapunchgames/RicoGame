@tool
extends Line2D
class_name Preview

@export_range(0, 360) var angle : float = 0:
	set(x):
		angle = x
		update_trajectory()
@export var speed : int = 500:
	set(x):
		speed = x
		update_trajectory()
@export var max_points = 200:
	set(x):
		max_points = x
		update_trajectory()
		
@onready var test_collision: CharacterBody2D = $TestCollision

func update_trajectory():
	if Engine.is_editor_hint():
		clear_points()
		var current_pos = Vector2.ZERO
		var dir = Vector2.RIGHT.rotated(deg_to_rad(angle)) * speed
		add_point(current_pos)
		for i in max_points:
			add_point(current_pos)
			
			if test_collision:
				var collision = test_collision.move_and_collide(dir * get_physics_process_delta_time(), false, true, true)
				if collision:
					dir = dir.bounce(collision.get_normal())
			
			current_pos += dir * get_physics_process_delta_time()
			if test_collision:
				test_collision.position = current_pos
	else:
		clear_points()
		hide()
