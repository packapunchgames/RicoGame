extends Node
class_name InputHandler


@export var cancel_zoom : float = 1.5
@export var offset_divisor : float = 5
@export var follower_offset_divisor : float = 2
@export var stiffness : int = 2
@export var scale_divisor : int = 2500
@export var hint_sensibility : int = 10

@onready var start_pos: Marker2D = $StartPos
@onready var stayer: Sprite2D = $StartPos/Stayer
@onready var follower: Sprite2D = $StartPos/Stayer/Follower

var distance : float

@export var subviewport_container : SubViewportContainer

func _input(_event: InputEvent) -> void:
	if Global.player and !Global.did_game_finish:
		if !Global.player.hasShot:
			var player_mouse_pos : Vector2 = Global.player.get_global_mouse_position()
			var mousePos : Vector2 = player_mouse_pos + get_display_offset(player_mouse_pos)
			mousePos.x += Global.display_offset.x
			if Input.is_action_just_pressed("press"):
				Global.player.hasStarted = true
				Global.player.initPos = mousePos
				start_pos.position = Global.player.initPos
			if Input.is_action_pressed("press") and Global.player.hasStarted:
				Global.player.pressVector = mousePos
				Global.player.heading = Global.player.pressVector.angle_to_point(Global.player.initPos)
				if Global.hint_angle <= 360:
					var reference_angle : float = rad_to_deg(Global.player.heading)
					if reference_angle < 0:
						reference_angle += 360
					if abs(reference_angle - Global.hint_angle) < hint_sensibility:
						Global.player.heading = deg_to_rad(Global.hint_angle)
				Global.player.sprite.rotation = Global.player.heading
				
				distance = Global.player.pressVector.distance_to(Global.player.initPos)
				
				Global.player.force = distance / Settings.sensitivity
				
				handle_joystick(mousePos)
			elif Input.is_action_just_released("press") and Global.player.hasStarted:
				start_pos.hide()
				Global.player.hasStarted = false
				Global.player.last_force_check = 0
				
				if distance > Global.player.difference:
					Global.player.hasShot = true
					Global.player.emit_signal("shot")
					
					Global.hit_stop(0.25)
					Global.player.speed = Global.player.force / 100
					
					Global.player.velocity = Vector2(cos(Global.player.heading), sin(Global.player.heading)) * Global.player.force
					Global.player.release.play()
				else:
					Global.player.cancel.play()
		elif Input.is_action_just_pressed("press"):
			Global.player.emit_signal("restart")


func handle_joystick(mousePos : Vector2) -> void:
	stayer.look_at(mousePos)
	stayer.offset.x = sqrt(distance) * stiffness / offset_divisor
	follower.offset.x = sqrt(distance) * stiffness / follower_offset_divisor
	
	if Global.player.force < Global.player.difference:
		stayer.scale = Vector2.ONE * cancel_zoom
	else:
		var size : Vector2 = Vector2(1 - distance / scale_divisor, 1 - distance / scale_divisor)
		size = clamp(size, Vector2.ONE * 0.5, Vector2.ONE)
		stayer.scale = size
	start_pos.show()

func get_display_offset(global_mouse_pos: Vector2) -> Vector2:
	var window_size : Vector2 = get_window().size
	var target_aspect_ratio := 1920.0 / 1080.0 
	var current_aspect_ratio := window_size.x / window_size.y
	var scale_factor: float
	if current_aspect_ratio > target_aspect_ratio:
		scale_factor = window_size.y / 1080.0
	else:
		scale_factor = window_size.x / 1920.0
	var subviewport_width := 1920.0 * scale_factor
	var subviewport_height := 1080.0 * scale_factor
	var offset_x := (window_size.x - subviewport_width) / 2.0
	var offset_y := (window_size.y - subviewport_height) / 2.0
	return Vector2(offset_x, offset_y)
