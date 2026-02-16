extends PlayerState


func update(_delta: float) -> void:
	if _can_transition_to_ladder_up():
		_state_machine.transition_to("LadderUp")
		return

	if _can_transition_to_ladder_down():
		_state_machine.transition_to("LadderDown")
		return

	if Input.is_action_just_pressed("jump"):
		_ladder_jump_transition()
		return

	if Input.is_action_just_pressed("dash") && _player.can_dash:
		_state_machine.transition_to("Dash")
		return

	if _player.is_on_floor() && !_player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Run")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	_player.animation_player.pause()
