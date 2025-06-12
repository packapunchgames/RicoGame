extends MarginContainer


@onready var version: Label = $Version

func _ready() -> void:
	version.text = "Version " + ProjectSettings.get("application/config/version") + " <3"
