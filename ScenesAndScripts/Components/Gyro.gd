extends Node
class_name Gyro

@export var actor : Control
@export var force : int
@export var dead_zone : float = 0.5

var start_pos : Vector2
var _current_offset : Variant = Vector2.ZERO

func _ready() -> void:
	await get_tree().process_frame
	start_pos = actor.position

func _process(delta: float) -> void:
	var accel := Input.get_accelerometer()
	var target_offset := Vector2.ZERO
	
	if abs(accel.x) > dead_zone:
		target_offset.x = clamp(accel.x * (force / 10.0), -abs(force), abs(force))
		
	if abs(accel.y) > dead_zone:
		target_offset.y = clamp(-accel.y * (force / 10.0), -abs(force), abs(force))
	
	_current_offset = _current_offset.lerp(target_offset, 8.0 * delta)
	
	actor.position = start_pos + _current_offset

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED:
			actor.position = start_pos
