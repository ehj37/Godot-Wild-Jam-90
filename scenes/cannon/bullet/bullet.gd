class_name Bullet

extends CharacterBody2D

const BULLET_SPEED: float = 225.0

var _current_speed: float

@onready var animation_player: BulletTimeAnimationPlayer = $BulletTimeAnimationPlayer


func _physics_process(_delta: float) -> void:
	velocity = Vector2.RIGHT * _current_speed
	move_and_slide()


func _ready() -> void:
	animation_player.play("fly")

	SignalBus.bullet_time_entered.connect(_on_bullet_time_entered)
	SignalBus.bullet_time_exited.connect(_on_bullet_time_exited)

	if BulletTimeManager.in_bullet_time:
		_current_speed = BULLET_SPEED * BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		_current_speed = BULLET_SPEED


func _on_bullet_time_entered() -> void:
	_current_speed = BULLET_SPEED * BulletTimeManager.BULLET_TIME_SLOW_FACTOR


func _on_bullet_time_exited() -> void:
	_current_speed = BULLET_SPEED


func _on_obstacle_detector_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.take_damage()

	queue_free()
