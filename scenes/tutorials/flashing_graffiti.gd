class_name FlashingGraffiti

extends Sprite2D

const FADE_IN_TIME: float = 0.5
const COLOR_1: Color = Color.GOLDENROD
const COLOR_2: Color = Color.YELLOW
const COLOR_1_TWEEN_TIME: float = 0.8
const COLOR_2_TWEEN_TIME: float = 1.2

@export var visible_on_start: bool = false


func fade_in() -> void:
	var fade_in_tween: Tween = get_tree().create_tween()
	fade_in_tween.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME)

	await fade_in_tween.finished
	_to_color_1()


func _ready() -> void:
	if visible_on_start:
		modulate.a = 1.0
		_to_color_1()
	else:
		modulate.a = 0.0


func _to_color_1() -> void:
	var color_1_tween: Tween = get_tree().create_tween()
	color_1_tween.tween_property(self, "modulate", COLOR_1, COLOR_1_TWEEN_TIME)
	await color_1_tween.finished

	_to_color_2()


func _to_color_2() -> void:
	var color_2_tween: Tween = get_tree().create_tween()
	color_2_tween.tween_property(self, "modulate", COLOR_2, COLOR_2_TWEEN_TIME)
	await color_2_tween.finished

	_to_color_1()
