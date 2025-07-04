extends TextureProgressBar

@export var offSet : Vector2 = Vector2(100, 46)
@export var parent : Player

func _ready() -> void:
	position = offSet
	pivot_offset = -offSet
	max_value = parent.topForce

func _process(delta: float) -> void:
	if parent.hasStarted:
		show()
		value = parent.force
		rotation_degrees = rad_to_deg(parent.heading)
		print(value)
		tint_progress = Color.GREEN.lerp(Color.RED, value / 500)
	else:
		hide()
