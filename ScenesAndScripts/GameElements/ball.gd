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
var collision : KinematicCollision2D

signal restart
signal shot

func _ready() -> void:
	Global.player = self


func _process(delta : float) -> void:
	speed *= deceleration
	if speed < 0.1:
		speed = 0
	
	collision  = move_and_collide(velocity * delta * speed)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
