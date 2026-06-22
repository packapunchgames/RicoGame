extends Control

@export var sub_viewport: SubViewport
@export var levels : Array[PackedScene]

var level_index : int = 0

func _ready() -> void:
	Global.connect("level_succeded", play_next_level)
	play_next_level()

func play_next_level() -> void:
	var world := sub_viewport.get_child_count()
	if world > 0:
		sub_viewport.get_child(0).queue_free()
	var new_level : PackedScene = levels[level_index]
	sub_viewport.add_child(new_level.instantiate())
	level_index += 1
