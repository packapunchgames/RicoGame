extends Node

var player : Ball = null

func hit_stop(duration):
	var initial_speed = player.speed
	var final_speed = initial_speed
	for i in duration * 100:
		final_speed *= player.deceleration
	var speed_difference = initial_speed - final_speed
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
	player.speed += speed_difference
