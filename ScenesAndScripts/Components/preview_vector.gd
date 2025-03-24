extends ProgressBar

@export var offSet : int = 100
@export var parent : Ball

func _ready() -> void:
	position.x = offSet
	pivot_offset.x = -offSet
	max_value = parent.topSpeed

func _process(delta: float) -> void:
	if parent.hasStarted:
		show()
		value = parent.force
		rotation_degrees = rad_to_deg(parent.heading)
	else:
		hide()
