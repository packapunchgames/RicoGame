extends Control

@export var sub_viewport: SubViewport
@export var levels : Array[PackedScene]

var result_screen : PackedScene = preload("res://ScenesAndScripts/UI/result_screen.tscn")
var victory_screen : PackedScene

var level_index : int = 0

@onready var animation_player: AnimationPlayer = $Transition/AnimationPlayer
@onready var security: Timer = $Security

func _ready() -> void:
	Global.connect("level_succeded", play_next_level)
	Global.connect("restart", restart)
	Global.connect("return_to_home", return_to_home)
	Global.connect("game_over", game_over)
	Global.did_try_second_chance = false
	play_next_level()
	if Global.did_game_restart:
		animation_player.play("intro_transition_restart")
		get_tree().paused = false
	else:
		animation_player.play("intro_transition")
	Global.lives = Resources.max_lives


func play_next_level() -> void:
	if security.is_stopped():
		security.start()
		if level_index < 30:
			var world := sub_viewport.get_child_count()
			if world > 0:
				sub_viewport.get_child(0).queue_free()
			var new_level : PackedScene = levels[level_index]
			sub_viewport.add_child(new_level.instantiate())
			level_index += 1
			#remove multiple levels
			if world > 1:
				for level in world:
					if level != 0:
						sub_viewport.get_child(level).queue_free()
		else:
			Global.game_paused.emit()
			get_tree().paused = true
			await get_tree().create_timer(1).timeout
			animation_player.play("slow_transition")
			victory_screen =  load("res://ScenesAndScripts/UI/victory_screen.tscn")

func restart() -> void:
	animation_player.play("close_transition")
	await animation_player.animation_finished
	get_tree().reload_current_scene()

func return_to_home() -> void:
	var start_screen : PackedScene = load("res://ScenesAndScripts/UI/StartScreen.tscn")
	animation_player.play("close_transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(start_screen)

func game_over() -> void:
	get_tree().paused = true
	Global.game_paused.emit()
	await get_tree().create_timer(1).timeout
	animation_player.play("close_transition")
	await animation_player.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_packed(result_screen)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slow_transition":
		get_tree().paused = false
		get_tree().change_scene_to_packed(victory_screen)
