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
		position.x = (window_size.x - target_width) / 2
		position.y = 0
	else:
		position.x = 0
		position.y = (window_size.y - target_height) / 2 
