extends PlayerState

const MANTLE_DURATION: float = 0.25
const START_POSITION_DISTANCE_FROM_WALL: int = 3
const START_POSITION_DISTANCE_FROM_FLOOR: int = 3
const END_POSITION_DISTANCE_FROM_WALL: int = 4
const END_POSITION_DISTANCE_FROM_FLOOR: int = 0

var _end_position: Vector2


func update(_delta: float) -> void:
	_player.velocity = Vector2.ZERO


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	_player.set_collision_mask_value(1, false)

	var collision_point_wall: Vector2 = _player.mantle_ray_cast_side_bottom.get_collision_point()
	var collision_point_floor: Vector2 = _player.mantle_ray_cast_down.get_collision_point()
	var corner_position: Vector2 = Vector2(collision_point_wall.x, collision_point_floor.y)
	var corner_offset_sign: int
	match _player.orientation:
		Player.Orientation.RIGHT:
			corner_offset_sign = 1
		Player.Orientation.LEFT:
			corner_offset_sign = -1

	var start_position_offset: Vector2 = Vector2(
		corner_offset_sign * START_POSITION_DISTANCE_FROM_WALL, START_POSITION_DISTANCE_FROM_FLOOR
	)
	var start_position: Vector2 = corner_position + start_position_offset
	var end_position_offset: Vector2 = Vector2(
		corner_offset_sign * END_POSITION_DISTANCE_FROM_WALL, END_POSITION_DISTANCE_FROM_FLOOR
	)
	_end_position = corner_position + end_position_offset

	_player.global_position = start_position

	get_tree().create_timer(MANTLE_DURATION).timeout.connect(_on_mantle_timer_timeout)


func exit() -> void:
	_player.set_collision_mask_value(1, true)


func _on_mantle_timer_timeout() -> void:
	_player.global_position = _end_position
	_state_machine.transition_to("Idle")
