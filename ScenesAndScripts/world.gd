extends Node2D

var initial_targets_data : Array[Dictionary] = []
var initial_obstacles_data : Array[Dictionary] = []
var initial_player_pos : Vector2

@onready var targets : Node2D = $Targets
@onready var obstacles : Node2D = $Obstacles

@onready var preview: Preview = $Ball/Preview
var has_used_hint : bool = false

var enemies_count : int

func _ready() -> void:
	Global.did_game_finish = false
	Global.hint_angle = 1000.0
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
		if child.has_method("update_position"):
			child_data["speed"] = child.speed
			child_data["start_position"] = child.start_position
			child_data["end_position"] = child.end_position
			child_data["progress"] = child.progress
			child_data["dir"] = child.dir
			if child is Polygon2D:
				child_data["interval"] = child.interval
		if child is Portals:
			child_data["radius"] = child.radius
			child_data["inner_area_percent"] = child.inner_area_percent
			child_data["portal_position"] = child.portal_position
			child_data["portal_2_position"] = child.portal_2_position
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
				if data.has("interval"):
					instance.interval = data["interval"]
			if data.has("speed"):
				instance.speed = data["speed"]
				instance.start_position = data["start_position"]
				instance.end_position = data["end_position"]
				instance.progress = data["progress"]
				instance.dir = data["dir"]
			if instance is Portals:
				instance.radius = data["radius"]
				instance.inner_area_percent = data["inner_area_percent"]
				instance.portal_position = data["portal_position"]
				instance.portal_2_position = data["portal_2_position"]
			parent_node.add_child(instance)

func restart() -> void:
	Global.player.speed = 0
	Global.player.trail_line.hide()
	Global.player.position = initial_player_pos
	Global.player.velocity = Vector2.ZERO
	Global.player.dir = 0
	Global.player.trail_line.clear_points()
	
	
	await get_tree().create_timer(0.1).timeout
	reset_and_reinstance_children(targets, initial_targets_data)
	reset_and_reinstance_children(obstacles, initial_obstacles_data)
	
	Global.player.set_deferred("hasShot", false)
	
	if has_used_hint:
		preview.show()
	
	await get_tree().create_timer(0.25).timeout
	Global.player.trail_line.show()


func hint() -> void:
	preview.highlight_trajectory()
	Global.hint_angle = preview.angle

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_H):
		if !has_used_hint and !Global.player.hasShot:
			if Resources.hints > 0:
				has_used_hint = true
				Resources.hints -= 1
				hint()

func _process(delta: float) -> void:
	enemies_count = get_tree().get_node_count_in_group("Targets")
	if  enemies_count == 0:
		if !Global.did_game_finish:
			Global.did_game_finish = true
			await get_tree().create_timer(0.25).timeout
			Global.emit_signal("level_succeded")
