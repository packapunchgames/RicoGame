extends Control

@export var sub_viewport: SubViewport
@export var level_succeder: LevelSucceder

func _ready() -> void:
	Global.connect("level_succeded", play_next_level)

func play_next_level() -> void:
	level_succeder.get_next_level()

func _on_level_succeder_level_changed() -> void:
	var world := sub_viewport.get_child_count()
	if world > 0:
		sub_viewport.get_child(0).queue_free()
	sub_viewport.add_child(level_succeder.current_level.instantiate()) 
