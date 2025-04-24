@tool
extends Node2D
class_name Portals

@onready var portal: Portal = $Portal
@onready var portal_2: Portal = $Portal2

@export_range(0,100) var inner_area_percent : int = 15:
	set(x):
		inner_area_percent = x
		update_values()
@export_range(0,500) var radius : int = 100:
	set(x):
		radius = x
		update_values()
@export var portal_position : Vector2:
	set(x):
		portal_position = x
		update_values()
@export var portal_2_position : Vector2:
	set(x):
		portal_2_position = x
		update_values()

func _ready() -> void:
	update_values()

func update_values() -> void:
	if portal:
		portal.radius = clamp(radius, 0, 500)
		portal.inner_area_percent = clamp(inner_area_percent, 0, 100)
		portal.position = portal_position
	if portal_2:
		portal_2.radius = clamp(radius, 0, 500)
		portal_2.inner_area_percent = clamp(inner_area_percent, 0, 100)
		portal_2.position = portal_2_position

func _on_portal_teleport() -> void:
	Global.player.trail_line.hide()
	portal_2.teleport_clean = false
	Global.player.global_position = portal_2.global_position
	await get_tree().create_timer(0.2).timeout
	Global.player.trail_line.show()

func _on_portal_2_teleport() -> void:
	Global.player.trail_line.hide()
	portal.teleport_clean = false
	Global.player.global_position = portal.global_position
	await get_tree().create_timer(0.2).timeout
	Global.player.trail_line.show()
