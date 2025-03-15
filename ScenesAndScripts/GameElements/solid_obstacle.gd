@tool
extends Polygon2D

@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

func _ready():
	if not Engine.is_editor_hint():
		update_collision_shape()

func update_collision_shape():
	if collision_polygon:
		collision_polygon.polygon = polygon

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if collision_polygon and collision_polygon.polygon != polygon:
			collision_polygon.polygon = polygon
