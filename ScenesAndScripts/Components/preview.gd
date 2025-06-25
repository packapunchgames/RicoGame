@tool
extends Line2D
class_name Preview

@export_range(0, 360) var angle : float = 0:
	set(x):
		angle = x
		update_trajectory(false)
@export var speed : int = 100:
	set(x):
		speed = x
		update_trajectory(false)
@export var max_points : int = 200:
	set(x):
		max_points = x
		update_trajectory(false)
@export var min_points : int = 50
@onready var test_collision: CharacterBody2D = $TestCollision
@export var collision_shape: CollisionShape2D 
var current_pos := Vector2.ZERO

func update_trajectory(single_bounce : bool) -> void:
	if Engine.is_editor_hint() and collision_shape:
		width = collision_shape.shape.radius * 2
		width_curve = null
		default_color = Color(1,1,1, 0.25)
	else:
		width = 10
		width_curve = load("res://ScenesAndScripts/Shaders/preview_width.tres")
		default_color = Color(1,1,1)
	
	
	clear_points()
	current_pos = Vector2.ZERO
	var dir : Vector2 = Vector2.RIGHT.rotated(deg_to_rad(angle)) * speed
	for i in max_points:
		add_point(current_pos)
		
		if test_collision:
			var collision : KinematicCollision2D = test_collision.move_and_collide(dir * get_physics_process_delta_time(), false, true, true)
			if collision:
				dir = dir.bounce(collision.get_normal())
				if single_bounce and i >= min_points:
					return
		elif single_bounce:
			max_points += 1
		
		current_pos += dir * get_physics_process_delta_time()
		if test_collision:
			test_collision.position = current_pos


func highlight_trajectory() -> void:
	update_trajectory(true)
	show()
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0.5), 1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 1).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()


func _ready() -> void:
	update_trajectory(false)
	if get_parent() is Player:
		get_parent().connect("shot", hide)
	if !Engine.is_editor_hint():
		hide()
