extends CharacterBody2D
class_name Ball


@export var topForce : int = 500
@export var boost : float = 0.5
@export var maxSpeed : float = 5.0
@export var deceleration : float = 0.99
var can_decelerate : bool = true

var speed_reserve : float = 0.0
var speed : float = 0:
	get:
		if speed < 0.1:
			speed = 0
		if speed > maxSpeed:
			speed_reserve += speed - maxSpeed
			speed -= speed - maxSpeed
		return speed


var initPos : Vector2
var pressVector : Vector2
var heading : float
var hasStarted : bool = false
var hasShot : bool = false
var collision : KinematicCollision2D

var last_force_check : int = 0
var difference : int = 100
var force : float:
	set(x):
		
		var force_diff : int = abs(round(force - last_force_check))
		force = clamp(x, 0, topForce)
		if force_diff >= difference:
			last_force_check = snapped(x, difference)
			last_force_check = clamp(last_force_check, 0, topForce)
			var vibrate_factor : int = 10000 / clamp(last_force_check, difference, topForce)
			Settings.vibrate(5, vibrate_factor)

@onready var trail_line: Line2D = $TrailLine

signal restart
signal shot

func _ready() -> void:
	Global.player = self

func _process(delta : float) -> void:
	if speed_reserve > 0.0 and speed < maxSpeed:
		speed += speed_reserve
		speed_reserve = 0
	if can_decelerate:
		speed *= deceleration
	
	collision  = move_and_collide(velocity * delta * speed)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
	
