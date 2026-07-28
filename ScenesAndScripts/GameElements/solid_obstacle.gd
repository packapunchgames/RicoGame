@tool
extends Polygon2D

@export var outline_width : int = 15
@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var outline: Line2D = $Outline

var custom_time : float = 0.0

func _ready() -> void:
	update_collision_shape()

func update_collision_shape() -> void:
	if collision_polygon:
		collision_polygon.polygon = polygon
	if outline:
		outline.points = polygon

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_collision_shape()
	elif Settings.visual_effects:
		custom_time += delta
		material.set_shader_parameter("time", custom_time)
