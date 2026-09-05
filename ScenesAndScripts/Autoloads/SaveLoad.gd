extends Node

const SAVE_FILE_PATH := "user://savedata.json"

var data : Dictionary = {
	money = 0,
	hints = 0,
	max_lives = 1,
	best_time = 0,
	is_first_run = true
}

func _ready() -> void:
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		save_data()
	else:
		load_data()

func save_data() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var json_string := JSON.stringify(data)
	file.store_string(json_string)
	file.close()

func load_data() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		var json_string := file.get_as_text()
		file.close()
		var parsed_data : Variant = JSON.parse_string(json_string)
		if parsed_data is Dictionary:
			for key : Variant in parsed_data:
				if data.has(key):
					data[key] = parsed_data[key]
		Resources.money = data.money
		Resources.hints = data.hints
		Resources.max_lives = data.max_lives
		Resources.best_time = data.best_time
