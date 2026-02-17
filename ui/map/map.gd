extends CanvasLayer

const FADE_IN_DURATION: float = 0.2
const FADE_OUT_DURATION: float = 0.1

var _fade_in_tween: Tween
var _fade_out_tween: Tween

@onready var container: Node2D = $Container


func _ready() -> void:
	container.modulate.a = 0.0
	SignalBus.map_opened.connect(_show)
	SignalBus.map_closed.connect(_hide)


func _show() -> void:
	if _fade_out_tween != null && _fade_out_tween.is_valid():
		_fade_out_tween.kill()

	_fade_in_tween = get_tree().create_tween()
	_fade_in_tween.tween_property(container, "modulate:a", 1.0, FADE_IN_DURATION)


func _hide() -> void:
	if _fade_in_tween != null && _fade_in_tween.is_valid():
		_fade_in_tween.kill()

	_fade_out_tween = get_tree().create_tween()
	_fade_out_tween.tween_property(container, "modulate:a", 0.0, FADE_OUT_DURATION)
