@tool
extends Node2D

@export var angle : float = 0
@export var max_bounces : int = 5
@export var ray_length : int = 500
@export var fixed_position : Vector2 = Vector2.ZERO

@onready var line : Line2D = $Line2D

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_laser_path()

func update_laser_path():
	var points = []
	var initial_position = fixed_position
	var current_position = initial_position
	var current_direction = Vector2.RIGHT.rotated(deg_to_rad(angle))
	
	points.append(current_position)
	
	for i in max_bounces:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.new()
		query.from = current_position
		query.to = current_position + current_direction * ray_length
		var result = space_state.intersect_ray(query)
		
		if result:
			points.append(result.position)
			var normal = result.normal
			current_direction = current_direction.bounce(normal)
			current_position = result.position
		else:
			points.append(current_position + current_direction * ray_length)
	
	line.points = points
