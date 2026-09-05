extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var version: Label = $MarginContainer/Version
@onready var record: Label = $MarginContainer/VBoxContainer/Record
@onready var margin_container: MarginContainer = $MarginContainer

@onready var settings: Control = $Overlays/Settings
@onready var credits_screen: Control = $Overlays/CreditsScreen

@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative

@onready var play_games_leaderboards_client: PlayGamesLeaderboardsClient = $MarginContainer/VBoxContainer/Leaderboard/PlayGamesLeaderboardsClient

var _leaderboards_cache: Array[PlayGamesLeaderboard] = []

signal go_tutorial

func _ready() -> void:
	version.text = "Version " + ProjectSettings.get("application/config/version") + " <3"
	
	if Resources.best_time > 0.0:
		var best_time := Resources.best_time
		var ms_bt := fmod(best_time, 1) * 10
		var secs_bt := fmod(best_time, 60)
		var mins_bt := fmod(best_time, 3600) / 60
		var hours_bt := fmod(fmod(best_time, 3600 * 60) / 3600, 24)
		record.text = "Your best time is: " + "%02d:%02d:%02d:%02d" % [ hours_bt, mins_bt, secs_bt, ms_bt]
	else:
		record.hide()
	
	if _leaderboards_cache.is_empty():
		play_games_leaderboards_client.load_all_leaderboards(true)


func show_self() -> void:
	animation_player.play("transition")

func _on_back_button_pressed() -> void:
	click_negative.play()
	animation_player.play_backwards("transition")
	Settings.vibrate(5, 60)

func _on_back() -> void:
	click_negative.play()
	animation_player.play("main_menu")
	Settings.vibrate(5, 60)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)

func _on_settings_pressed() -> void:
	click_positive.play()
	animation_player.play_backwards("main_menu")
	settings.show_self()
	Settings.vibrate(5, 60)

func _on_credits_pressed() -> void:
	click_positive.play()
	animation_player.play_backwards("main_menu")
	credits_screen.show_self()
	Settings.vibrate(5, 60)

func _on_tutorial_pressed() -> void:
	click_positive.play()
	Settings.vibrate(5, 60)
	go_tutorial.emit()


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

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if visible and margin_container.visible:
			_on_back_button_pressed()
