extends Node

const SAVE_FILE_PATH := "user://savedata.json"
const CLOUD_SAVE_NAME := "main_save"

var snapshots_client : PlayGamesSnapshotsClient

var data : Dictionary = {
	money = 0,
	hints = 0,
	max_lives = 1,
	best_time = 0,
	is_first_run = true,
	player_id = ""
}

func _ready() -> void:
	GodotPlayGameServices.initialize()
	snapshots_client = PlayGamesSnapshotsClient.new()
	add_child(snapshots_client)
	
	snapshots_client.game_saved.connect(_on_cloud_game_saved)
	snapshots_client.game_loaded.connect(_on_cloud_game_loaded)
	snapshots_client.conflict_emitted.connect(_on_cloud_conflict)
	
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		save_data()
	else:
		load_data()

func _update_resources() -> void:
	Resources.money = data.money
	Resources.hints = data.hints
	Resources.max_lives = data.max_lives
	Resources.best_time = data.best_time

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
		_update_resources()


func save_cloud_data() -> void:
	save_data()
	
	if Global.is_authenticated:
		var json_string := JSON.stringify(data)
		var byte_array := json_string.to_utf8_buffer()
		var description := "Money: %s, Best time: %s" % [data.money, data.best_time]
		
		snapshots_client.save_game(CLOUD_SAVE_NAME, description, byte_array)

func load_cloud_data() -> void:
	snapshots_client.load_game(CLOUD_SAVE_NAME, false)

func _on_cloud_game_saved(is_saved: bool, save_data_name: String, save_data_description: String) -> void:
	if is_saved:
		print("Successfully saved at: ", save_data_name)
	else:
		printerr("Failed to save")

func _on_cloud_game_loaded(snapshot: PlayGamesSnapshot) -> void:
	if snapshot == null:
		print("No cloud save found. Uploading current local save...")
		save_cloud_data()
		return
	var json_string := snapshot.content.get_string_from_utf8()
	var cloud_data : Variant = JSON.parse_string(json_string)
	if cloud_data is Dictionary:
		var local_id : String = data.get("player_id", "")
		var cloud_id : String = cloud_data.get("player_id", "")
		var local_lives: int = data.get("max_lives", 1)
		var cloud_lives: int = cloud_data.get("max_lives", 1)
		var local_money: int = data.get("money", 0)
		var cloud_money: int = cloud_data.get("money", 0)
		
		if cloud_id == local_id and local_lives == cloud_lives and local_money == cloud_money:
			return
		
		var use_cloud := false
		print("local player id: ", data.get("player_id", ""))
		print("cloud player id: ", cloud_data.get("player_id", ""))
		if local_id != cloud_id:
			print("player id mismatch, loading cloud data")
			use_cloud = true
		else:
			if cloud_lives > local_lives:
				use_cloud = true
			elif local_lives > cloud_lives:
				use_cloud = false
			else:
				if cloud_money > local_money:
					use_cloud = true
				elif local_money > cloud_money:
					use_cloud = false
		
		if use_cloud:
			print("Cloud data is further ahead. Updating local save.")
			for key : Variant in cloud_data:
				data[key] = cloud_data[key]
			save_data()
			_update_resources()
		else:
			print("Local data is further ahead. Overwriting cloud save.")
			save_cloud_data()

func _on_cloud_conflict(conflict: PlayGamesSnapshotConflict) -> void:
	print("Conflict detected between local and server snapshots: ", conflict)

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED:
		save_cloud_data()
