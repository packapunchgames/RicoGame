extends Node2D

var bg1 : Texture2D = preload("res://Art/PNG Files/Backgrounds/bg1.jpg")
var bg2 : Texture2D = preload("res://Art/PNG Files/Backgrounds/bg2.png")
var bg3 : Texture2D = preload("res://Art/PNG Files/Backgrounds/bg3.jpg")

@onready var background: TextureRect = $Background

func _ready() -> void:
	var parent_name : String = get_parent().scene_file_path
	parent_name = parent_name.get_slice("/", 4)
	var parent_level_number : int = int(parent_name[0] + parent_name[1])
	if parent_level_number < 10:
		background.texture = bg1
	elif parent_level_number < 20:
		background.texture = bg2
	elif parent_level_number < 30:
		background.texture = bg3
