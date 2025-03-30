extends Control

var world : PackedScene
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func _ready() -> void:
	Global.connect("level_succeded", play_next_level)
	sub_viewport.add_child(LevelSucceder.current_level.instantiate())

func play_next_level() -> void:
	sub_viewport.get_child(0).queue_free()
	sub_viewport.add_child(LevelSucceder.get_next_level().instantiate())
