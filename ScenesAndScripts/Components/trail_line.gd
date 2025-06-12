extends Line2D

@export var ball : Player
@export var multiplier : int = 6
var max_points : int
var can_spawn : bool = true

func _process(delta: float) -> void:
	if can_spawn:
		max_points = round(ball.speed * multiplier)
		
		add_point(ball.global_position)
		
		if points.size() >= max_points:
			remove_point(0)
