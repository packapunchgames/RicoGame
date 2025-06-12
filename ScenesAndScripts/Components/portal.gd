@tool
extends Area2D
class_name Portal

signal teleport

@export var collision_shape : CollisionShape2D
@export var inner_area_collision : CollisionShape2D
@onready var inner_area: Area2D = $InnerArea


@export var inner_area_percent : int = 15:
	set(x):
		inner_area_percent = clamp(x, 0, 100)
		if inner_area_collision:
			var inner_area_size : float = (inner_area_percent * radius) / 100
			inner_area_collision.shape.radius = inner_area_size
@export var radius : int = 100:
	set(x):
		radius = clamp(x, 0, 500)
		if collision_shape:
			collision_shape.shape.radius = radius
		if inner_area_collision:
			var inner_area_size : float = (inner_area_percent * radius) / 100
			inner_area_collision.shape.radius = inner_area_size
var is_entered : bool = false
var teleport_clean : bool = true
var entered_body : PhysicsBody2D

func _process(delta: float) -> void:
	if teleport_clean:
		if is_entered:
			if inner_area.get_overlapping_bodies().size() > 0:
				teleport.emit()

func _on_body_entered(body: PhysicsBody2D) -> void:
	entered_body = body
	body = body
	is_entered = true

func _on_body_exited(body: PhysicsBody2D) -> void:
	entered_body = null
	is_entered = false
	teleport_clean = true
	body = null
