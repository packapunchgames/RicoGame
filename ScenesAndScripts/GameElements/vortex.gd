@tool
extends Area2D
class_name Vortex

@export var radius : int = 100
@export var raw_force : int = 100
@export var deceleration : float = 0.98
@export var threshold : int = 5
@export var weakening : float = 0.25

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var ball : Ball

func _process(delta: float) -> void:
	set_radius()
	
	if has_overlapping_bodies():
		var body : CharacterBody2D = get_overlapping_bodies()[0]
		if body is Ball:
			ball = body
			Global.player.can_decelerate = false
		
		var distance : float = global_position.distance_to(body.global_position)
		var direction : Vector2 = body.global_position.direction_to(global_position)
		
		var attraction_force : float
		if distance < threshold:
			body.global_position = lerp(body.global_position, global_position, delta * 10)
		elif distance < radius / 2:
			attraction_force = raw_force #* weakening
		else:
			attraction_force = raw_force
		body.velocity += direction * attraction_force * delta
		body.velocity *= deceleration
		
	else:
		if ball:
			ball.can_decelerate = true


func set_radius() -> void:
	if collision_shape.shape.radius != radius:
		collision_shape.shape.radius = radius + 64#half of player's size
