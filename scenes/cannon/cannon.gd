class_name Cannon

extends Node2D

enum SpawnDirection { UP, RIGHT, DOWN, LEFT }

const LIGHT_UP_COLOR: Color = Color.YELLOW

@export var screen: Screen
@export var bullet_type_pattern: Array[Bullet.Type]
@export var spawn_direction: SpawnDirection = SpawnDirection.RIGHT
@export var time_between_bullets: float = 0.3

var _bullet_queue: Array[Bullet.Type]

@onready var sprite_lights: Sprite2D = $SpriteLights
@onready var bullet_packed_scene: PackedScene = preload("./bullet/bullet.tscn")
@onready var bullet_spawn_timer: BulletTimeTimer = $BulletSpawnTimer


func _ready() -> void:
	assert(
		bullet_type_pattern.size() > 0,
		"Cannon at " + str(global_position) + " does not specify bullet type pattern."
	)
	bullet_spawn_timer.update_wait_time(time_between_bullets)


func _on_bullet_spawn_timer_timeout() -> void:
	if _bullet_queue.size() == 0:
		_bullet_queue = bullet_type_pattern.duplicate()

	var bullet: Bullet = bullet_packed_scene.instantiate()
	bullet.type = _bullet_queue.pop_front()
	match spawn_direction:
		SpawnDirection.UP:
			bullet.spawn_direction = Bullet.SpawnDirection.UP
		SpawnDirection.RIGHT:
			bullet.spawn_direction = Bullet.SpawnDirection.RIGHT
		SpawnDirection.DOWN:
			bullet.spawn_direction = Bullet.SpawnDirection.DOWN
		SpawnDirection.LEFT:
			bullet.spawn_direction = Bullet.SpawnDirection.LEFT
	bullet.global_position = global_position
	LevelManager.current_level.add_child(bullet)
	SoundEffectManager.play_effect_for_screen(SoundEffectConfig.Type.CANNON_FIRE, screen)
