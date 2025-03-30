extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	Settings.vibrate(10, 100)
	Global.hit_stop(0.05)
	if body is Ball:
		body.speed += body.boost
	queue_free()
