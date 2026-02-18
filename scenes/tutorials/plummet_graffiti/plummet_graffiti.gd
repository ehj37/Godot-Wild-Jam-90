extends Sprite2D

const FADE_IN_TIME: float = 0.5


func fade_in() -> void:
	var fade_in_tween: Tween = get_tree().create_tween()
	fade_in_tween.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME)


func _ready() -> void:
	modulate.a = 0.0
