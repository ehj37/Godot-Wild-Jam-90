extends PlayerState

const LADDER_UP_SPEED: float = 50.0


func update(_delta: float) -> void:
	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_player.velocity.y = -LADDER_UP_SPEED
		return

	if Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	_state_machine.transition_to("LadderIdle")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity.x = 0.0
	_snap_to_ladder_center()


func _snap_to_ladder_center() -> void:
	# TODO: Might need to change from StaticBody2D if and when I switch to tile map ladders
	var collider: StaticBody2D = _player.ladder_ray_cast_up.get_collider()
	var collider_collision_shape: CollisionShape2D = collider.get_child(
		_player.ladder_ray_cast_up.get_collider_shape()
	)
	var target_x_pos: float = collider_collision_shape.global_position.x

	if _player.global_position.x != target_x_pos:
		_player.global_position.x = target_x_pos
