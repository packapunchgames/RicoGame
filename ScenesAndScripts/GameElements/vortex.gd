@tool
extends Area2D
class_name Vortex

@export var radius : int = 100
@export var raw_force : int = 100
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _process(delta: float) -> void:
	if collision_shape.shape.radius != radius:
		collision_shape.shape.radius = radius + 64
	
	if has_overlapping_bodies():
		var body : CharacterBody2D = get_overlapping_bodies()[0]
		var distance : float = global_position.distance_to(body.global_position)
		var direction : Vector2 = body.global_position.direction_to(global_position)
		var attraction_force : float = raw_force * clamp((1 - distance / radius), 0.25, INF)
		body.velocity += attraction_force * direction
