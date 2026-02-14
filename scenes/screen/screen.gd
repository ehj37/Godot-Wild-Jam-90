@tool

class_name Screen

extends Node2D

@export var screen_above: Screen:
	set(value):
		value.global_position = Vector2(global_position.x, global_position.y - 270)
		screen_above = value

@export var screen_below: Screen:
	set(value):
		value.global_position = Vector2(global_position.x, global_position.y + 270)
		screen_below = value

@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	if Engine.is_editor_hint():
		set_meta("_edit_lock_", true)
	else:
		panel_container.visible = false


func _on_body_entered(_body: Player) -> void:
	SignalBus.screen_entered.emit(self)
