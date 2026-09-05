extends Node

var config := ConfigFile.new()
const SAVE_FILE_PATH := "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		config.set_value("SYSTEM", "master_volume", 1.0)
		config.set_value("SYSTEM", "music", 1.0)
		config.set_value("SYSTEM", "sfx", 1.0)
		config.set_value("SYSTEM", "vibration", 0.6)
		config.set_value("GAME", "sensitivity", -0.5)
		config.set_value("GAME", "vfx", true)
		config.set_value("GAME", "timer", false)
		config.save(SAVE_FILE_PATH)
	else:
		config.load(SAVE_FILE_PATH)
		load_system_setting()
		load_game_setting()

func save_system_setting(key : String, value : Variant) -> void:
	config.set_value("SYSTEM", key, value)
	config.save(SAVE_FILE_PATH)

func load_system_setting() -> void:
	var system_settings : Dictionary = {}
	for key in config.get_section_keys("SYSTEM"):
		system_settings[key] = config.get_value("SYSTEM", key)
	Settings.master_volume = system_settings["master_volume"]
	Settings.music = system_settings["music"]
	Settings.sfx = system_settings["sfx"]
	Settings.vibration = system_settings["vibration"]

func save_game_setting(key : String, value : Variant) -> void:
	config.set_value("GAME", key, value)
	config.save(SAVE_FILE_PATH)

func load_game_setting() -> void:
	var game_settings : Dictionary = {}
	for key in config.get_section_keys("GAME"):
		game_settings[key] = config.get_value("GAME", key)
	Settings.sensitivity = game_settings["sensitivity"]
	Settings.visual_effects = game_settings["vfx"]
	Settings.show_timer = game_settings["timer"]
