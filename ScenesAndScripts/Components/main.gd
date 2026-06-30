extends Control

@export var sub_viewport: SubViewport
@export var levels : Array[PackedScene]

var level_index : int = 0

@onready var animation_player: AnimationPlayer = $Transition/AnimationPlayer

func _ready() -> void:
	Global.connect("level_succeded", play_next_level)
	Global.connect("restart", restart)
	Global.connect("return_to_home", return_to_home)
	play_next_level()
	if Global.did_game_restart:
		animation_player.play("intro_transition_restart")
		get_tree().paused = false
	else:
		animation_player.play("intro_transition")
	Global.lives = Resources.max_lives


func play_next_level() -> void:
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

func restart() -> void:
	animation_player.play("restart_transition")
	await animation_player.animation_finished
	get_tree().reload_current_scene()

func return_to_home() -> void:
	var start_screen : PackedScene = load("res://ScenesAndScripts/UI/StartScreen.tscn")
	animation_player.play("restart_transition")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(start_screen)
