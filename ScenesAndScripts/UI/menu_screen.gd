extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var version: Label = $MarginContainer/Version

@onready var settings: Control = $Overlays/Settings

@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative

@onready var play_games_leaderboards_client: PlayGamesLeaderboardsClient = $MarginContainer/VBoxContainer/Leaderboard/PlayGamesLeaderboardsClient

var _leaderboards_cache: Array[PlayGamesLeaderboard] = []

func _ready() -> void:
	version.text = "Version " + ProjectSettings.get("application/config/version") + " <3"
	
	if _leaderboards_cache.is_empty():
		play_games_leaderboards_client.load_all_leaderboards(true)


func show_self() -> void:
	animation_player.play("transition")

func _on_back_button_pressed() -> void:
	click_negative.play()
	animation_player.play_backwards("transition")
	Settings.vibrate(5, 20)

func _on_back() -> void:
	click_negative.play()
	animation_player.play("main_menu")
	Settings.vibrate(5, 20)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)

func _on_settings_pressed() -> void:
	click_positive.play()
	animation_player.play_backwards("main_menu")
	settings.show_self()
	Settings.vibrate(5, 20)




func _on_all_leaderboards_loaded(leaderboards: Array[PlayGamesLeaderboard]) -> void:
	_leaderboards_cache = leaderboards
	#if not _leaderboards_cache.is_empty():
		#for leaderboard: PlayGamesLeaderboard in _leaderboards_cache:
			#var container := _leaderboard_display.instantiate() as Control
			#container.play_games_leaderboard = leaderboard
			#container.play_games_leaderboards_client = play_games_leaderboards_client
			#leaderboard_displays.add_child(container)


func _on_leaderboard_pressed() -> void:
	play_games_leaderboards_client.show_all_leaderboards()
