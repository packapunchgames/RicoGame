extends Node2D


func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	resize()

func resize():
	var window_size = get_viewport().get_visible_rect().size
	var target_aspect_ratio = 16.0 / 9.0
	var target_width = window_size.y * target_aspect_ratio
	var target_height = window_size.x / target_aspect_ratio
	if window_size.x / window_size.y > target_aspect_ratio:
		var pos = Vector2((window_size.x - target_width) / 2, 0)
		position = pos
	else:
		var pos = Vector2(0, (window_size.y - target_height) / 2 )
		position = pos
