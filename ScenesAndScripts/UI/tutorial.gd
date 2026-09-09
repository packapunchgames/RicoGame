extends Control

var index : int = 0

@export var main_scene : PackedScene
@export var imgs : Array[Texture2D]
@export var titleArray : Array[String]
@export var descriptionsArray : Array[String]

@onready var title: Label = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Title
@onready var image: TextureRect = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Image
@onready var description: Label = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Description

@onready var left: TextureButton = $MarginContainer/PanelContainer/HBoxContainer/LeftArrow/Left
@onready var right: TextureButton = $MarginContainer/PanelContainer/HBoxContainer/RightArrow/Right
@onready var go: Button = $MarginContainer/PanelContainer/HBoxContainer/VBoxContainer/Go

@onready var click_positive: AudioStreamPlayer = $Audio/ClickPositive
@onready var click_negative: AudioStreamPlayer = $Audio/ClickNegative
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var play_games_sign_in_client: PlayGamesSignInClient = $PlayGamesSignInClient

var sign_in_retries := 3

func update_data() -> void:
	if index == 4:
		right.hide()
		go.show()
	else:
		go.hide()
		right.show()
		left.show()
		if index == 0:
			left.hide()
	title.text = titleArray[index]
	image.texture = imgs[index]
	description.text = descriptionsArray[index]

func _on_left_pressed() -> void:
	index -= 1
	click_negative.play()
	Settings.vibrate(5,80)
	update_data()

func _on_right_pressed() -> void:
	index += 1
	click_positive.play()
	Settings.vibrate(5,80)
	update_data()

func _on_go_pressed() -> void:
	animation_player.play_backwards("transition")
	click_positive.play()
	Settings.vibrate(5,80)
	SaveLoad.data.is_first_run = false
	await animation_player.animation_finished
	SaveLoad.save_data()
	get_tree().change_scene_to_packed(main_scene)

func button_hold_vibrate() -> void:
	Settings.vibrate(5, 40)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if index > 0:
			_on_left_pressed()

func _ready() -> void:
	play_games_sign_in_client.is_authenticated()


func _on_play_games_sign_in_client_user_authenticated(is_authenticated: bool) -> void:
	Global.is_authenticated = is_authenticated
	if !is_authenticated and sign_in_retries > 0:
		play_games_sign_in_client.sign_in()
		sign_in_retries -= 1
	else:
		SaveLoad.load_cloud_data()
