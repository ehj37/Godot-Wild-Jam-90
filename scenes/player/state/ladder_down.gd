extends PlayerState

const LADDER_DOWN_SPEED: float = 150.0


func update(_delta: float) -> void:
	if Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_player.velocity.y = LADDER_DOWN_SPEED
		return

	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	_state_machine.transition_to("LadderIdle")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity.x = 0.0
	_snap_to_ladder_center()


func _snap_to_ladder_center() -> void:
	var target_x_pos: float = TileMapUtils.get_ladder_target_x(_player.ladder_ray_cast_down)
	if _player.global_position.x != target_x_pos:
		_player.global_position.x = target_x_pos
