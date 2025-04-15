extends Line2D

@export var ball : Player
@export var multiplier : int = 6
var max_points : int

func _process(delta: float) -> void:
	max_points = round(ball.speed * multiplier)
	
	add_point(ball.global_position)
	
	if points.size() >= max_points:
		remove_point(0)
