extends Control

@onready var play_games_sign_in_client: PlayGamesSignInClient = $PlayGamesSignInClient

@export var game_scene : PackedScene

func _enter_tree() -> void:
	GodotPlayGameServices.initialize()

func _ready() -> void:
	if not GodotPlayGameServices.android_plugin:
		print("Plugin Not Found!")
	else:
		print("Main Menu")
	
	play_games_sign_in_client.is_authenticated()
	play_games_sign_in_client.sign_in()

func _on_play_games_sign_in_client_user_authenticated(is_authenticated: bool) -> void:
	print("Hi from Godot! User is authenticated? %s" % is_authenticated)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
