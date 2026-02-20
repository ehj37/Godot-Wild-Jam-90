class_name Bullet

extends CharacterBody2D

enum Type { EXTRA_DASH, STRENGTH, RECHARGE_JUMP, DAMAGE, RECHARGE_DASH_AND_JUMP }
enum SpawnDirection { UP, RIGHT, DOWN, LEFT }

const BULLET_SPEED: float = 225.0
const TRAIL_AND_AUREOLE_ALPHA: float = 0.5
const TRAIL_FADE_IN_TIME: float = 0.1
const EXTRA_DASH_COLOR: Color = Color.FUCHSIA
const STRENGTH_COLOR: Color = Color.ORANGE
const RECHARGE_JUMP_COLOR: Color = Color.AQUAMARINE
const DAMAGE_COLOR: Color = Color.RED
const RECHARGE_DASH_AND_JUMP_COLOR: Color = Color.GOLD

const TYPE_TO_COLOR: Dictionary = {
	Type.EXTRA_DASH: EXTRA_DASH_COLOR,
	Type.STRENGTH: STRENGTH_COLOR,
	Type.RECHARGE_JUMP: RECHARGE_JUMP_COLOR,
	Type.DAMAGE: DAMAGE_COLOR,
	Type.RECHARGE_DASH_AND_JUMP: RECHARGE_DASH_AND_JUMP_COLOR
}

var type: Type = Type.EXTRA_DASH
var spawn_direction: SpawnDirection
var _direction: Vector2
var _type_color: Color
var _current_speed: float
var _dying: bool = false

@onready var animation_player: BulletTimeAnimationPlayer = $BulletTimeAnimationPlayer
@onready var sprite_trail: Sprite2D = $SpriteTrail
@onready var sprite_aureole: Sprite2D = $SpriteAureole
@onready var sprite_bullet: Sprite2D = $SpriteBullet
@onready var bullet_flash_timer: BulletTimeTimer = $BulletFlashTimer


func _physics_process(_delta: float) -> void:
	if _dying:
		velocity = Vector2.ZERO
	else:
		velocity = _direction * _current_speed
	move_and_slide()


func _ready() -> void:
	match spawn_direction:
		SpawnDirection.UP:
			_direction = Vector2.UP
		SpawnDirection.RIGHT:
			_direction = Vector2.RIGHT
		SpawnDirection.DOWN:
			_direction = Vector2.DOWN
		SpawnDirection.LEFT:
			_direction = Vector2.LEFT

	_type_color = TYPE_TO_COLOR.get(type)
	sprite_aureole.modulate = Color(_type_color, TRAIL_AND_AUREOLE_ALPHA)
	sprite_bullet.modulate = _type_color

	sprite_trail.rotate(_direction.angle())
	sprite_trail.modulate.a = 0.0
	var trail_alpha_tween: Tween = get_tree().create_tween()
	trail_alpha_tween.tween_property(
		sprite_trail, "modulate:a", TRAIL_AND_AUREOLE_ALPHA, TRAIL_FADE_IN_TIME
	)

	SignalBus.bullet_time_entered.connect(_on_bullet_time_entered)
	SignalBus.bullet_time_exited.connect(_on_bullet_time_exited)

	if BulletTimeManager.in_bullet_time:
		_current_speed = BULLET_SPEED * BulletTimeManager.BULLET_TIME_SLOW_FACTOR
	else:
		_current_speed = BULLET_SPEED

	animation_player.play("fly")


func _on_bullet_time_entered() -> void:
	_current_speed = BULLET_SPEED * BulletTimeManager.BULLET_TIME_SLOW_FACTOR


func _on_bullet_time_exited() -> void:
	_current_speed = BULLET_SPEED


func _on_obstacle_detector_area_body_entered(body: Node2D) -> void:
	if _dying:
		return

	if body is Player:
		var player: Player = body
		player.on_bullet_connect(type)

	_dying = true
	animation_player.play("die")
	await animation_player.animation_finished

	queue_free()


func _on_bullet_flash_timer_timeout() -> void:
	if _dying:
		return

	if sprite_bullet.modulate == Color.WHITE:
		sprite_bullet.modulate = _type_color
	else:
		sprite_bullet.modulate = Color.WHITE
