extends PlayerState

const LADDER_UP_SPEED: float = 50.0


func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		_ladder_jump_transition()
		return

	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_player.velocity.y = -LADDER_UP_SPEED
		return

	if _can_transition_to_ladder_down():
		_state_machine.transition_to("LadderDown")
		return

	if Input.is_action_just_pressed("dash") && _player.can_dash:
		_state_machine.transition_to("Dash")
		return

	_state_machine.transition_to("LadderIdle")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity.x = 0.0
	_snap_to_ladder_center()
	_player.animation_player.play("ladder_up")

	_player.recharge_dash_and_jump()


func _snap_to_ladder_center() -> void:
	var target_x_pos: float = TileMapUtils.get_ladder_target_x(_player.ladder_ray_cast_up)
	if _player.global_position.x != target_x_pos:
		_player.global_position.x = target_x_pos
