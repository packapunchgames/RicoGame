extends CharacterBody2D
class_name Ball

var speed : float = 0
@export var deceleration : float = 0.99
@export var topSpeed : int = 500

var initPos : Vector2
var pressVector : Vector2
var heading : float
var force : float
var hasStarted : bool = false

func _input(_event: InputEvent) -> void:
	var mousePos := get_global_mouse_position()
	if Input.is_action_just_pressed("press"):
		hasStarted = true
		initPos = mousePos
	if Input.is_action_pressed("press") and hasStarted:
		pressVector = mousePos
		heading = pressVector.angle_to_point(initPos)
		force = pressVector.distance_to(initPos)
	elif Input.is_action_just_released("press") and hasStarted:
		hasStarted = false
		force = clamp(force, 0, topSpeed)
		speed = force / 100
		
		velocity = Vector2(cos(heading), sin(heading)) * force

func _process(delta):
	var collision = move_and_collide(velocity * delta * speed)
	
	speed *= deceleration
	if speed < 0.1:
		speed = 0
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
