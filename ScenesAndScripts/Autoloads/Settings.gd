extends Node

var master_volume : float = 1.0
var music : float = 1.0
var sfx : float = 1.0
var vibration : float = 0.5
var sensitivity : float = 1

enum shuffleModes {OFF, ON, TRUESHUFFLE}
var shuffle : shuffleModes = shuffleModes.OFF

func vibrate(duration : int, percent : int) -> void:
	Input.vibrate_handheld(duration, (vibration * percent) / 100)

func _ready() -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), linear_to_db(master_volume)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), linear_to_db(music)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), linear_to_db(sfx)
	)
