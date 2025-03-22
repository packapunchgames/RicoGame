extends CharacterBody2D
class_name Ball

var speed : float = 0
@export var deceleration : float = 0.99
@export var topSpeed : int = 500
@export var boost : float = 0.5

var initPos : Vector2
var pressVector : Vector2
var heading : float
var force : float
var hasStarted : bool = false
var hasShot : bool = false

signal restart
signal shot

func _ready() -> void:
	Global.player = self

func _input(_event: InputEvent) -> void:
	if !hasShot:
		var mousePos := get_global_mouse_position()
		if Input.is_action_just_pressed("press"):
			hasStarted = true
			initPos = mousePos
		if Input.is_action_pressed("press") and hasStarted:
			pressVector = mousePos
			heading = pressVector.angle_to_point(initPos)
			
			force = pressVector.distance_to(initPos)
			force = clamp(force, 0, topSpeed)
		elif Input.is_action_just_released("press") and hasStarted:
			hasShot = true
			hasStarted = false
			shot.emit()
			
			Global.hit_stop(0.25)
			force = clamp(force, 0, topSpeed)
			speed = force / 100
			
			velocity = Vector2(cos(heading), sin(heading)) * force
	elif Input.is_action_just_pressed("press"):
		restart.emit()

func _process(delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta * speed)
	
	speed *= deceleration
	if speed < 0.1:
		speed = 0
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
