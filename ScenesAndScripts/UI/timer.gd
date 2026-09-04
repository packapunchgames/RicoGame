extends Label

var time : float
var time_passed : String

func _process(delta: float) -> void:
	visible = Settings.show_timer
	time += delta
	
	var ms := fmod(time, 1) * 10
	var secs := fmod(time, 60)
	var mins := fmod(time, 3600) / 60
	var hours := fmod(fmod(time, 3600 * 60) / 3600, 24)
	
	if hours < 1:
		time_passed = "%02d:%02d:%02d" % [ mins, secs, ms]
	else:
		time_passed = "%02d:%02d:%02d:%02d" % [ hours, mins, secs, ms]
	text = time_passed
	
	Global.time = time
