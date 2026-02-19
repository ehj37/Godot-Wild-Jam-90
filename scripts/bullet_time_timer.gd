class_name BulletTimeTimer

extends Timer

var _normal_wait_time: float = wait_time


func update_wait_time(new_wait_time: float) -> void:
	_normal_wait_time = new_wait_time
	if BulletTimeManager.in_bullet_time:
		wait_time = _normal_wait_time / BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		wait_time = _normal_wait_time


func _ready() -> void:
	SignalBus.bullet_time_entered.connect(_on_bullet_time_entered)
	SignalBus.bullet_time_exited.connect(_on_bullet_time_exited)
	timeout.connect(_restore_wait_time)

	if BulletTimeManager.in_bullet_time:
		wait_time = _normal_wait_time / BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		wait_time = _normal_wait_time


func _on_bullet_time_entered() -> void:
	var adjusted_remaining_time: float = time_left / BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	if adjusted_remaining_time > 0:
		stop()
		wait_time = adjusted_remaining_time
		start()


func _on_bullet_time_exited() -> void:
	var adjusted_remaining_time: float = time_left * BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	if adjusted_remaining_time > 0:
		stop()
		wait_time = adjusted_remaining_time
		start()


func _restore_wait_time() -> void:
	if BulletTimeManager.in_bullet_time:
		wait_time = _normal_wait_time / BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		wait_time = _normal_wait_time

	# Things get weird without this. I think the timer times out and restarts,
	# but before the wait time has been restored.
	if !one_shot:
		start()
