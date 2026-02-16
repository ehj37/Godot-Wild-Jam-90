extends PlayerState


func update(_delta: float) -> void:
	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	if Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	if Input.is_action_just_pressed("jump"):
		if !_player.get_input_direction().is_zero_approx():
			_state_machine.transition_to("Airborne", {"jump": true})
			return

		_player.num_jumps = 1
		_state_machine.transition_to("Airborne")
		return

	if Input.is_action_just_pressed("dash") && _player.can_dash:
		_state_machine.transition_to("Dash")
		return

	if _player.is_on_floor() && !_player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Run")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	_player.animation_player.pause()
