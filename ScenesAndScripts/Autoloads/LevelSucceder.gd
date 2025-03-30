extends Node

var levels : Array = get_levels_array("res://ScenesAndScripts/Levels/")
var grouped_levels : Array = get_grouped_levels_arrays("res://ScenesAndScripts/Levels/")
var selected_array : Array

var array_1 : Array = grouped_levels[0]
var array_2 : Array = grouped_levels[1]

var index : int = 0
var current_level : PackedScene
var group_index : int = 0

func _ready() -> void:
	update_selected_array()

func update_selected_array() -> void:
	if Settings.shuffle:
		selected_array = grouped_levels
		current_level = selected_array[0][0]
	else:
		selected_array = levels
		current_level = selected_array[0]

func get_next_level() -> PackedScene:
	index += 1
	if Settings.shuffle:
		current_level = selected_array[group_index][index]
		if index == 9:
			index = 0
	else:
		current_level = selected_array[index]
	return current_level

func get_name_from_packed(scene : PackedScene) -> String:
	return scene.resource_path.get_file().get_basename()

func get_levels_array(directory_path: String) -> Array[PackedScene]:
	var levels_array: Array[PackedScene] = []
	var dir := DirAccess.open(directory_path)
	dir.list_dir_begin()
	var file_name : String = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var scene : PackedScene = load(directory_path + "/" + file_name)
			if scene:
				levels_array.append(scene)
		file_name = dir.get_next()
	dir.list_dir_end()
	return levels_array

func get_grouped_levels_arrays(directory_path: String) -> Array:
	var grouped_arrays: Array = []
	var current_group: Array[PackedScene] = []
	var current_group_index : int = 0
	for scene : PackedScene in levels:
		var file_name : String = get_name_from_packed(scene)
		var level_number : int = int(file_name[0])
		if level_number == current_group_index:
			current_group.append(scene)
		else:
			grouped_arrays.append(current_group)
			current_group = [scene]
			current_group_index += 1
	grouped_arrays.append(current_group)
	return grouped_arrays
