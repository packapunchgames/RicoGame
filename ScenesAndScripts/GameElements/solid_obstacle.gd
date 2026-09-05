@tool
extends Polygon2D

@export var outline_width : int = 15
@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var outline: Line2D = $Outline

var custom_time : float = 0.0

func _ready() -> void:
	update_collision_shape()
	
	var parent_name : String = get_parent().get_parent().scene_file_path
	parent_name = parent_name.get_slice("/", 4)
	var parent_level_number : int = int(parent_name[0] + parent_name[1])
	if parent_level_number < 10:
		material.set_shader_parameter("tint_color", Color.PURPLE)
	elif parent_level_number < 20:
		material.set_shader_parameter("tint_color", Color.YELLOW)
	elif parent_level_number < 30:
		material.set_shader_parameter("tint_color", Color.NAVAJO_WHITE)

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
