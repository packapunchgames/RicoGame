extends CharacterBody2D
class_name Ball

var speed : float = 0:
	get:
		if speed < 0.1:
			speed = 0
		return speed
		
@export var deceleration : float = 0.99
@export var topForce : int = 500
@export var boost : float = 0.5

var initPos : Vector2
var pressVector : Vector2
var heading : float
var hasStarted : bool = false
var hasShot : bool = false
var collision : KinematicCollision2D

var last_force_check : int = 0
var difference : int = 125
var force : float:
	set(x):
		force = clamp(x, 0, topForce)
		if abs(round(force - last_force_check)) >= difference:
			Settings.vibrate(5, 10)
			last_force_check = snapped(x, difference)

@onready var trail_line: Line2D = $TrailLine

signal restart
signal shot

func _ready() -> void:
	Global.player = self


func _process(delta : float) -> void:
	speed *= deceleration
	
	collision  = move_and_collide(velocity * delta * speed)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
