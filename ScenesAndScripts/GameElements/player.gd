extends CharacterBody2D
class_name Player

@export_group("Sounds")
@export var drag : AudioStreamPlayer
@export var release : AudioStreamPlayer
@export var cancel : AudioStreamPlayer
@export var tap : AudioStreamPlayer

@export_group("")
@export var topForce : int = 500
@export var boost : float = 0.5
@export var maxSpeed : float = 5.0
@export var deceleration : float = 0.99

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
var dir : float

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
			drag.pitch_scale = 1.5 + last_force_check / 1000
			drag.play()

@onready var trail_line: Line2D = $TrailLine
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox

signal restart
signal shot

func _ready() -> void:
	Global.player = self
	dir = 0
	heading = 0
	rotation = 0

func _process(delta : float) -> void:
	handle_speed()
	
	rotate_sprite(delta)
	
	collision  = move_and_collide(velocity * delta * speed)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		tap.play()

func handle_speed() -> void:
	if speed_reserve > 0.0 and speed < maxSpeed:
		speed += speed_reserve
		speed_reserve = 0
	speed *= deceleration

func stop() -> void:
	speed = 0
	speed_reserve = 0
	velocity = Vector2.ZERO

func rotate_sprite(delta : float) -> void:
	if hasShot:
		dir = speed * delta * 10
		sprite.rotation += dir

func level_ended() -> void:
	stop()
	await get_tree().create_timer(0.25).timeout
	return

func _on_hurtbox_body_entered(body: Node2D) -> void:
	stop()
	collision_shape.set_deferred("disabled", true)
	hurtbox.set_deferred("monitoring", false)


func _on_restart() -> void:
	collision_shape.set_deferred("disabled", false)
	hurtbox.set_deferred("monitoring", true)
	stop()
	trail_line.hide()
	dir = 0
	global_rotation_degrees = 0.0
	trail_line.clear_points()
	trail_line.can_spawn = false
