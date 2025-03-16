extends Camera2D

@export var parent : Ball
@export var aim_zoom := 4

func _ready() -> void:
	get_tree().get_root().size_changed.connect(update_camera_limits)
	update_camera_limits()

func update_camera_limits():
	var window_size = get_viewport().get_visible_rect().size
	var target_aspect_ratio = 16.0 / 9.0
	var world_position = position
	
	var offset_x = 0.0
	if window_size.x / window_size.y > target_aspect_ratio:
		var target_width = window_size.y * target_aspect_ratio
		offset_x = (window_size.x - target_width)
	
	limit_left = world_position.x + offset_x
	limit_right = world_position.x + offset_x + 1920
	limit_top = world_position.y
	limit_bottom = world_position.y + 1080

func _process(delta: float) -> void:
	if parent.hasStarted:
		var increase = parent.force / (aim_zoom * 10000)
		zoom.x = 1 + increase
		zoom.y = 1 + increase
	else:
		zoom = Vector2.ONE
