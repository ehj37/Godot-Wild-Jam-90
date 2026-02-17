class_name ExpandingSquare

extends PanelContainer

signal finished

const EXPAND_DURATION: float = 4.0
const MAX_SIZE: float = 100

var color: Color


func _ready() -> void:
	var style_box: StyleBoxFlat = StyleBoxFlat.new()
	style_box.set_border_width_all(1)
	style_box.bg_color = Color.TRANSPARENT
	style_box.border_color = color
	add_theme_stylebox_override("panel", style_box)

	var panel_tween: Tween = get_tree().create_tween()
	panel_tween.set_parallel()

	panel_tween.tween_property(self, "size", Vector2(MAX_SIZE, MAX_SIZE), EXPAND_DURATION)
	var final_position: Vector2 = Vector2(-MAX_SIZE / 2, -MAX_SIZE / 2)
	panel_tween.tween_property(self, "position", final_position, EXPAND_DURATION)
	panel_tween.tween_property(self, "modulate:a", 0.0, EXPAND_DURATION)

	panel_tween.finished.connect(func() -> void: finished.emit())
