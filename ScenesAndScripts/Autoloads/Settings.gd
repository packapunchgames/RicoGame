extends Node

var vibration : float = -1.0
var sensitivity : float = 1.0
var shuffle : bool = false

func vibrate(duration : int, percent : int) -> void:
	Input.vibrate_handheld(duration, (vibration * percent) / 100)
