extends Node
class_name InputHandler

var ball : Ball
@export var sub_viewport_container : SubViewportContainer
@export var cancel_range : float = 100.0
@export var cancel_zoom : float = 1.5
@export var offset_divisor : int = 10
@export var scale_divisor : int = 2500
@export var follower_smooth_speed : int = 10

@onready var start_pos: Marker2D = $StartPos
@onready var stayer: Sprite2D = $StartPos/Stayer
@onready var follower: Sprite2D = $Follower

var distance : float

func _ready() -> void:
	ball = Global.player

func _input(_event: InputEvent) -> void:
	if !ball.hasShot:
		var mousePos := sub_viewport_container.get_local_mouse_position()
		if Input.is_action_just_pressed("press"):
			ball.hasStarted = true
			ball.initPos = mousePos
			start_pos.position = ball.initPos
		if Input.is_action_pressed("press") and ball.hasStarted:
			ball.pressVector = mousePos
			ball.heading = ball.pressVector.angle_to_point(ball.initPos)
			
			distance = ball.pressVector.distance_to(ball.initPos)
			
			ball.force = distance / Settings.sensitivity
			
			handle_joystick(mousePos)
		elif Input.is_action_just_released("press") and ball.hasStarted:
			stayer.hide()
			follower.hide()
			ball.hasStarted = false
			
			if distance > cancel_range:
				ball.hasShot = true
				ball.emit_signal("shot")
				
				Global.hit_stop(0.25)
				ball.speed = ball.force / 100
				
				ball.velocity = Vector2(cos(ball.heading), sin(ball.heading)) * ball.force
	elif Input.is_action_just_pressed("press"):
		ball.emit_signal("restart")


func handle_joystick(mousePos : Vector2) -> void:
	follower.position = follower.position.lerp(mousePos, follower_smooth_speed * get_physics_process_delta_time())
	
	stayer.look_at(mousePos)
	stayer.offset.x = distance / offset_divisor
	follower.position = mousePos
	if distance < cancel_range:
		stayer.scale = Vector2.ONE * cancel_zoom
	else:
		var size : Vector2 = Vector2(1 - distance / scale_divisor, 1 - distance / scale_divisor)
		size = clamp(size, Vector2.ONE * 0.5, Vector2.ONE)
		stayer.scale = size
	stayer.show()
	follower.show()
