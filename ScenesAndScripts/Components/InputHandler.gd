extends Node
class_name InputHandler

@export var cancel_range : float = 100.0
@export var cancel_zoom : float = 1.5
@export var offset_divisor : float = 5
@export var follower_offset_divisor : float = 2
@export var stiffness : int = 2
@export var scale_divisor : int = 2500

@onready var start_pos: Marker2D = $StartPos
@onready var stayer: Sprite2D = $StartPos/Stayer
@onready var follower: Sprite2D = $StartPos/Stayer/Follower

var distance : float


func _input(_event: InputEvent) -> void:
	if Global.player:
		if !Global.player.hasShot:
			var mousePos := Global.player.get_global_mouse_position()
			if Input.is_action_just_pressed("press"):
				Global.player.hasStarted = true
				Global.player.initPos = mousePos
				start_pos.position = Global.player.initPos
			if Input.is_action_pressed("press") and Global.player.hasStarted:
				Global.player.pressVector = mousePos
				Global.player.heading = Global.player.pressVector.angle_to_point(Global.player.initPos)
				
				distance = Global.player.pressVector.distance_to(Global.player.initPos)
				
				Global.player.force = distance / Settings.sensitivity
				
				handle_joystick(mousePos)
			elif Input.is_action_just_released("press") and Global.player.hasStarted:
				start_pos.hide()
				Global.player.hasStarted = false
				Global.player.last_force_check = 0
				
				if distance > cancel_range:
					Global.player.hasShot = true
					Global.player.emit_signal("shot")
					
					Global.hit_stop(0.25)
					Global.player.speed = Global.player.force / 100
					
					Global.player.velocity = Vector2(cos(Global.player.heading), sin(Global.player.heading)) * Global.player.force
		elif Input.is_action_just_pressed("press"):
			Global.player.emit_signal("restart")


func handle_joystick(mousePos : Vector2) -> void:
	stayer.look_at(mousePos)
	stayer.offset.x = sqrt(distance) * stiffness / offset_divisor
	follower.offset.x = sqrt(distance) * stiffness / follower_offset_divisor
	
	if Global.player.force < cancel_range:
		stayer.scale = Vector2.ONE * cancel_zoom
	else:
		var size : Vector2 = Vector2(1 - distance / scale_divisor, 1 - distance / scale_divisor)
		size = clamp(size, Vector2.ONE * 0.5, Vector2.ONE)
		stayer.scale = size
	start_pos.show()
