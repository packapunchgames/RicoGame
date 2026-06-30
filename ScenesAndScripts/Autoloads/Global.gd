extends Node

var player : Player = null
var overlay : Overlay = null
var did_game_finish : bool = false
var display_offset : Vector2 = Vector2.ZERO
var hint_angle : float = 0.0
var has_used_hint : bool = false
var lives : int = 3:
	set(x):
		lives = x
		lives_changed.emit()

var did_game_restart : bool = false #changes the transition
var did_try_second_chance : bool = false

signal level_succeded
signal game_paused
signal game_resumed
signal lives_changed
signal restart
signal return_to_home
signal game_over
signal show_revive_screen

func hit_stop(duration : float) -> void:
	if Settings.visual_effects == true:
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
