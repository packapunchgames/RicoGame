extends ResourcePreloader
class_name LevelSucceder

signal level_changed

var levels : Array
var index : int = 0
var current_level : PackedScene:
	set(x):
		current_level = x
		level_changed.emit()


func _enter_tree() -> void:
	levels = get_resource_list()
	match Settings.shuffle:
		Settings.shuffleModes.OFF:
			current_level = get_resource(levels[index])
	

func get_next_level() -> void:
	index += 1
	match Settings.shuffle:
		Settings.shuffleModes.OFF:
			current_level = get_resource(levels[index])
