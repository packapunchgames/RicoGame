extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	Input.vibrate_handheld(50)
	if body is Ball:
		body.speed += body.boost
	queue_free()
