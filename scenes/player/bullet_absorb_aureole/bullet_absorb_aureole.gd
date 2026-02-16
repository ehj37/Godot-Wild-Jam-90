class_name BulletAbsorbAureole

extends Sprite2D

const EXTRA_DASH_COLOR: Color = Color.FUCHSIA
const STRENGTH_COLOR: Color = Color.ORANGE

const INITIAL_FLASH_DURATION: float = 0.1
const FADE_OUT_DURATION: float = 0.1

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func flash(bullet_type: Bullet.Type) -> void:
	modulate = Color.WHITE

	var color: Color
	match bullet_type:
		Bullet.Type.EXTRA_DASH:
			color = EXTRA_DASH_COLOR
		Bullet.Type.STRENGTH:
			color = STRENGTH_COLOR

	var initial_flash_tween: Tween = get_tree().create_tween()
	initial_flash_tween.tween_property(self, "modulate", color, INITIAL_FLASH_DURATION)
	await initial_flash_tween.finished

	var fade_out_tween: Tween = get_tree().create_tween()
	fade_out_tween.tween_property(self, "modulate", Color(color, 0.0), FADE_OUT_DURATION)
