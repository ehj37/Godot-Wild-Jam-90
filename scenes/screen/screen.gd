@tool

class_name Screen

extends Node2D

@export var spawn_point: Marker2D

@export var screen_above: Screen:
	set(value):
		value.global_position = Vector2(global_position.x, global_position.y - 272)
		screen_above = value

@export var screen_below: Screen:
	set(value):
		value.global_position = Vector2(global_position.x, global_position.y + 272)
		screen_below = value

@onready var panel_container: PanelContainer = $PanelContainer


func center() -> Vector2:
	return global_position + Vector2(240, 136)


func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("_edit_lock_", true)

		panel_container.visible = false


func _on_body_entered(_body: Player) -> void:
	SignalBus.screen_entered.emit(self)


func _on_body_exited(_body: Player) -> void:
	SignalBus.screen_exited.emit(self)
