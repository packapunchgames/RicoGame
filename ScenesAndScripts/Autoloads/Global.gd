extends Node

var player : Ball = null
var overlay : Overlay = null

func hit_stop(duration : float) -> void:
	var initial_speed := player.speed
	var final_speed := initial_speed
	for i in duration * 100:
		final_speed *= player.deceleration
	var speed_difference : float = initial_speed - final_speed
	Engine.time_scale = 0
	overlay.hit_flash(duration)
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
	player.speed += speed_difference
