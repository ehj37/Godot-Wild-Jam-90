extends Node

const BULLET_TIME_SLOW_FACTOR: float = 0.1

var in_bullet_time: bool = false


func _ready() -> void:
	SignalBus.bullet_time_entered.connect(func() -> void: in_bullet_time = true)
	SignalBus.bullet_time_exited.connect(func() -> void: in_bullet_time = false)
