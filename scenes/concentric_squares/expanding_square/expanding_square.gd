class_name ExpandingSquare

extends PanelContainer

signal finished

@export var max_size: float = 100.0
@export var expand_duration: float = 4.0

var color: Color


func _ready() -> void:
	var style_box: StyleBoxFlat = StyleBoxFlat.new()
	style_box.set_border_width_all(1)
	style_box.bg_color = Color.TRANSPARENT
	style_box.border_color = color
	add_theme_stylebox_override("panel", style_box)

	var panel_tween: Tween = get_tree().create_tween()
	panel_tween.set_parallel()

	panel_tween.tween_property(self, "size", Vector2(max_size, max_size), expand_duration)
	var final_position: Vector2 = Vector2(-max_size / 2, -max_size / 2)
	panel_tween.tween_property(self, "position", final_position, expand_duration)
	panel_tween.tween_property(self, "modulate:a", 0.0, expand_duration)

	panel_tween.finished.connect(func() -> void: finished.emit())
