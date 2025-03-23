extends Node2D

var initial_targets_data : Array[Dictionary] = []
var initial_obstacles_data : Array[Dictionary] = []
var initial_player_pos : Vector2

@onready var targets : Node2D = $Targets
@onready var obstacles : Node2D = $Obstacles

@onready var preview: Preview = $Ball/Preview
var has_used_hint : bool = false

func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	resize()
	
	Global.player.restart.connect(restart)
	initial_player_pos = Global.player.position
	save_initial_children_data(targets, initial_targets_data)
	save_initial_children_data(obstacles, initial_obstacles_data)

func save_initial_children_data(parent_node : Node2D, data_array : Array) -> void:
	for child: Node in parent_node.get_children():
		var child_data : Dictionary = {
			"resource_path": child.scene_file_path,
			"initial_position": child.position
		}
		if child is Polygon2D:
			child_data["polygon"] = child.polygon
		if child is MovingTarget:
			child_data["speed"] = child.speed
			child_data["start_position"] = child.start_position
			child_data["end_position"] = child.end_position
			child_data["progress"] = child.progress
			child_data["dir"] = child.dir
		data_array.append(child_data)

func reset_and_reinstance_children(parent_node : Node2D, initial_data : Array) -> void:
	for child in parent_node.get_children():
		child.queue_free()
	for data: Dictionary in initial_data:
		var resource := load(data["resource_path"])
		if resource is PackedScene:
			var instance : Node2D = resource.instantiate()
			instance.position = data["initial_position"]
			if instance is Polygon2D:
				instance.polygon = data["polygon"]
			if instance is MovingTarget:
				instance.speed = data["speed"]
				instance.start_position = data["start_position"]
				instance.end_position = data["end_position"]
				instance.progress = data["progress"]
				instance.dir = data["dir"]
			parent_node.add_child(instance)

func restart() -> void:
	Global.player.position = initial_player_pos
	Global.player.speed = 0
	Global.player.velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.1).timeout
	reset_and_reinstance_children(targets, initial_targets_data)
	reset_and_reinstance_children(obstacles, initial_obstacles_data)
	
	Global.player.set_deferred("hasShot", false)
	
	if has_used_hint:
		preview.show()

func resize() -> void:
	var window_size : Vector2 = get_viewport().get_visible_rect().size
	var target_aspect_ratio : float = 16.0 / 9.0
	var target_width : float = window_size.y * target_aspect_ratio
	var target_height : float = window_size.x / target_aspect_ratio
	if window_size.x / window_size.y > target_aspect_ratio:
		var pos := Vector2((window_size.x - target_width) / 2, 0)
		position = pos
	else:
		var pos := Vector2(0, (window_size.y - target_height) / 2 )
		position = pos

func hint() -> void:
	preview.highlight_trajectory()

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_H):
		if Global.hints > 0:
			has_used_hint = true
			Global.hints -= 1
			hint()
