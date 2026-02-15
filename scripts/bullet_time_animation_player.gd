class_name BulletTimeAnimationPlayer

extends AnimationPlayer


func _ready() -> void:
	SignalBus.bullet_time_entered.connect(_on_bullet_time_entered)
	SignalBus.bullet_time_exited.connect(_on_bullet_time_exited)

	if BulletTimeManager.in_bullet_time:
		speed_scale = BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		speed_scale = 1.0


func _on_bullet_time_entered() -> void:
	speed_scale = BulletTimeManager.BULLET_TIME_SLOW_FACTOR


func _on_bullet_time_exited() -> void:
	speed_scale = 1.0
