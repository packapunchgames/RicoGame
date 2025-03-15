extends Node

func hit_stop(duration):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true)
	Engine.time_scale = 1
