extends Node

var player : Player = null
var overlay : Overlay = null
var did_game_finish : bool = false
var display_offset : Vector2 = Vector2.ZERO
var hint_angle : float = 0.0
var has_used_hint : bool = false
var lives : int = 3

signal level_succeded

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
