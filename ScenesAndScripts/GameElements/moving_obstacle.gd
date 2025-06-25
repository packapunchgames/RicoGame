@tool
extends Polygon2D

@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var body: StaticBody2D = $StaticBody2D
@onready var outline: Line2D = $Outline

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

@export var interval : float = 0.0
var time_waited : float = 0.0

enum DIRECTION {FIRST = 1, SECOND = -1}
@export var dir : DIRECTION = DIRECTION.SECOND

func _ready() -> void:
	if not Engine.is_editor_hint():
		update_collision_shape()

func update_collision_shape() -> void:
	if collision_polygon and collision_polygon.polygon != polygon:
		collision_polygon.polygon = polygon
	if outline:
		outline.points = polygon

func update_position() -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		position = start_position.lerp(end_position, progress)
	else:
		if Global.player:
			if Global.player.collision and Global.player.collision.get_collider() == body:
				await get_tree().process_frame
			else:
				position = start_position.lerp(end_position, progress)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_collision_shape()
	else:
		match dir:
			DIRECTION.FIRST:
				progress = move_toward(progress, 1.0, speed * delta)
				if progress == 1.0:
					if time_waited > interval:
						time_waited = 0.0
						dir = DIRECTION.SECOND
					else:
						time_waited += delta
			DIRECTION.SECOND:
				progress = move_toward(progress, 0.0, speed * delta)
				if progress == 0.0:
					if time_waited > interval:
						time_waited = 0.0
						dir = DIRECTION.FIRST
					else:
						time_waited += delta

#func _draw() -> void:
	#if Engine.is_editor_hint():
		#var local_start := to_local(start_position)
		#var local_end := to_local(end_position)
		#draw_line(local_start, local_end, Color.BLACK, 2.0)
		#draw_circle(local_start, 50, Color.GREEN)
		#draw_circle(local_end, 50, Color.BLUE)
