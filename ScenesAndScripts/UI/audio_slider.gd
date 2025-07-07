extends HSlider

@export var bus_name : String

var bus_index : int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index, linear_to_db(new_value)
	)
	match bus_name:
		"Master":
			Settings.master_volume = new_value
		"Music":
			Settings.music = new_value
		"SFX":
			Settings.sfx = new_value
