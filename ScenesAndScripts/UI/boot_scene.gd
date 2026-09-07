extends ColorRect

var loaded_scene : PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_games_sign_in_client: PlayGamesSignInClient = $PlayGamesSignInClient

func _ready() -> void:
	play_games_sign_in_client.is_authenticated()
	play_games_sign_in_client.sign_in()
	if SaveLoad.data.is_first_run:
		loaded_scene = load("res://ScenesAndScripts/UI/tutorial.tscn")
	else:
		loaded_scene = load("res://ScenesAndScripts/UI/StartScreen.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(loaded_scene)

func _on_play_games_sign_in_client_user_authenticated(is_authenticated: bool) -> void:
	Global.is_authenticated = is_authenticated
	animation_player.play_backwards("fade")
