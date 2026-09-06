extends Control

@onready var time_display: Label = $MarginContainer/VBoxContainer/TimeDisplay
@onready var time_animation: AnimationPlayer = $MarginContainer/VBoxContainer/TimeDisplay/TimeAnimation

@onready var victory_music: AudioStreamPlayer = $Audio/VictoryMusic
@onready var info: Label = $MarginContainer/Info
@onready var money_collected: Label = $MarginContainer/VBoxContainer/HBoxContainer/MoneyCollected

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var music: AudioStreamPlayer = $Audio/Music

var home_screen : PackedScene

func _ready() -> void:
	home_screen = load("res://ScenesAndScripts/UI/StartScreen.tscn")
	var time := Global.time
	var ms := fmod(time, 1) * 10
	var secs := fmod(time, 60)
	var mins := fmod(time, 3600) / 60
	var hours := fmod(fmod(time, 3600 * 60) / 3600, 24)
	time_display.text = "%02d:%02d:%02d:%02d" % [ hours, mins, secs, ms]
	if Global.money_gained > 0:
			Resources.money += Global.money_gained
			SaveLoad.data.money = Resources.money
			money_collected.text = "You collected x" + str(Global.money_gained)
			Global.money_gained = 0
			Global.potential_kills = 0
	
	if Resources.best_time == 0:
		victory_music.playing = true
		info.text = "You've just unlocked endless mode! Challenge your best time against others, you can find the leaderboard in the home screen!"
		Resources.best_time = time
		SaveLoad.data.best_time = Resources.best_time
	else:
		if Resources.best_time > time:
			victory_music.playing = true
			info.text = "New best time!"
			Resources.best_time = time
			SaveLoad.data.best_time = Resources.best_time
			time_animation.play("best_time")
		else:
			var best_time := Resources.best_time
			var ms_bt := fmod(best_time, 1) * 10
			var secs_bt := fmod(best_time, 60)
			var mins_bt := fmod(best_time, 3600) / 60
			var hours_bt := fmod(fmod(best_time, 3600 * 60) / 3600, 24)
			info.text = "Personal record: " + "%02d:%02d:%02d:%02d" % [ hours_bt, mins_bt, secs_bt, ms_bt]
			music.play()


func _on_return_to_home_button_down() -> void:
	Settings.vibrate(5, 40)


func _on_return_to_home_pressed() -> void:
	animation_player.play_backwards("fade")
	click_positive.play()
	Settings.vibrate(5, 60)
	await animation_player.animation_finished
	SaveLoad.save_data()
	get_tree().change_scene_to_packed(home_screen)
