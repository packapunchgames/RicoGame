extends ProgressBar

@export var offSet : int = 100
var parent : Ball

func _ready() -> void:
	position.x = offSet
	pivot_offset.x = -offSet
	parent = get_parent()
	max_value = parent.topSpeed

func _process(delta: float) -> void:
	if parent.hasStarted:
		show()
		value = parent.force
		rotation_degrees = rad_to_deg(parent.heading)
	else:
		hide()
