extends Camera2D

const SCREEN_TRANSITION_DURATION: float = 0.75


func _ready() -> void:
	SignalBus.snap_camera_to.connect(_snap_camera_to)


func _snap_camera_to(screen: Screen) -> void:
	var target_global_position: Vector2 = screen.global_position + Vector2(240, 136)

	if ScreenManager.is_initial_screen:
		global_position = target_global_position
		return

	TimeScaleManager.freeze_time()

	var global_position_tween: Tween = get_tree().create_tween().set_ignore_time_scale(true)
	(
		global_position_tween
		. tween_property(
			self, "global_position", target_global_position, SCREEN_TRANSITION_DURATION
		)
		. set_trans(Tween.TRANS_CUBIC)
	)
	await global_position_tween.finished

	TimeScaleManager.unfreeze_time()
