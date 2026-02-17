extends CanvasLayer

signal complete

const FADE_OUT_DURATION: float = 2.0
const FADE_IN_DURATION: float = 2.0

@onready var color_rect: ColorRect = $ColorRect


func fade_in() -> void:
	var alpha_tween: Tween = get_tree().create_tween()
	alpha_tween.tween_property(color_rect, "color:a", 0.0, FADE_IN_DURATION)
	await alpha_tween.finished

	complete.emit()


func fade_out() -> void:
	var alpha_tween: Tween = get_tree().create_tween()
	alpha_tween.tween_property(color_rect, "color:a", 1.0, FADE_OUT_DURATION)
	await alpha_tween.finished

	complete.emit()


func _ready() -> void:
	color_rect.color.a = 0.0
