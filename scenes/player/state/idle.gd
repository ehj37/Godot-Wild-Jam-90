extends PlayerState

const IDLE_COLOR: Color = Color.RED


func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("dash") && _player.can_dash:
		_state_machine.transition_to("Dash")
		return

	if _can_transition_to_ladder_up():
		_state_machine.transition_to("LadderUp")
		return

	if _can_transition_to_ladder_down():
		_state_machine.transition_to("LadderDown")
		return

	if !_player.is_on_floor():
		_player.num_jumps = 1
		_state_machine.transition_to("Airborne")
		return

	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	if !_player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Run")
		return

	_player.velocity.x = move_toward(_player.velocity.x, 0, delta * Player.MOVE_DECELERATION)


func enter(_data: Dictionary = {}) -> void:
	_player.animation_player.play("idle_right")
	_player.recharge_dash_and_jump()
