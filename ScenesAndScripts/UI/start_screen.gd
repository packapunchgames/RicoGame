extends Control

@onready var play_games_sign_in_client: PlayGamesSignInClient = $PlayGamesSignInClient
@onready var click_positive: AudioStreamPlayer = $Sounds/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Sounds/ClickNegative

@export var game_scene : PackedScene

func _enter_tree() -> void:
	GodotPlayGameServices.initialize()

func _ready() -> void:
	play_games_sign_in_client.is_authenticated()
	play_games_sign_in_client.sign_in()

func _on_play_games_sign_in_client_user_authenticated(is_authenticated: bool) -> void:
	print("Hi from Godot! User is authenticated? %s" % is_authenticated)


func _on_start_button_pressed() -> void:
	#click_positive.play()
	get_tree().change_scene_to_packed(game_scene)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)
