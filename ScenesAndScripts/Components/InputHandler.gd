extends Node
class_name InputHandler

var ball : Ball
@export var sub_viewport_container : SubViewportContainer

func _ready() -> void:
	ball = Global.player

func _input(_event: InputEvent) -> void:
	if !ball.hasShot:
		var mousePos := sub_viewport_container.get_local_mouse_position()
		if Input.is_action_just_pressed("press"):
			ball.hasStarted = true
			ball.initPos = mousePos
		if Input.is_action_pressed("press") and ball.hasStarted:
			ball.pressVector = mousePos
			ball.heading = ball.pressVector.angle_to_point(ball.initPos)
			
			ball.force = ball.pressVector.distance_to(ball.initPos)
			ball.force = clamp(ball.force, 0, ball.topSpeed)
		elif Input.is_action_just_released("press") and ball.hasStarted:
			ball.hasShot = true
			ball.hasStarted = false
			ball.emit_signal("shot")
			
			Global.hit_stop(0.25)
			ball.force = clamp(ball.force, 0, ball.topSpeed)
			ball.speed = ball.force / 100
			
			ball.velocity = Vector2(cos(ball.heading), sin(ball.heading)) * ball.force
	elif Input.is_action_just_pressed("press"):
		ball.emit_signal("restart")
