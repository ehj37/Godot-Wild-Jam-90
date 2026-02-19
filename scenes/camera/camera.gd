extends Camera2D

const SCREEN_TRANSITION_DURATION: float = 0.75

@export var initial_screen: Screen


func _ready() -> void:
	SignalBus.snap_camera_to.connect(_snap_camera_to)
	SignalBus.snap_and_zoom.connect(_snap_and_zoom)
	global_position = initial_screen.center()


func _snap_camera_to(screen: Screen, instant: bool) -> void:
	# Rest zoom—may have been changed from _snap_and_zoom
	zoom = Vector2.ONE

	var target_global_position: Vector2 = screen.center()
	if global_position == target_global_position:
		return

	if instant:
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


func _snap_and_zoom(snap_position: Vector2, zoom_multiplier: int) -> void:
	global_position = snap_position
	zoom = Vector2(zoom_multiplier, zoom_multiplier)
