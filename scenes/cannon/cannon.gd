class_name Cannon

extends StaticBody2D

@onready var bullet_packed_scene: PackedScene = preload("./bullet/bullet.tscn")
@onready var timer: BulletTimeTimer = $BulletSpawnTimer
@onready var timer_label: Label = $TimerLabel


func _process(_delta: float) -> void:
	timer_label.text = str(timer.time_left)


func _on_bullet_spawn_timer_timeout() -> void:
	var bullet: Bullet = bullet_packed_scene.instantiate()
	bullet.global_position = global_position
	LevelManager.current_level.add_child(bullet)
