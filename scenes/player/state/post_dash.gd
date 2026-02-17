extends PlayerState

const POST_DASH_PAUSE_DURATION: float = 0.2


func update(_delta: float) -> void:
	_player.velocity = Vector2.ZERO

	if _can_transition_to_ladder_up():
		_state_machine.transition_to("LadderUp")
		return

	if _can_transition_to_ladder_down():
		_state_machine.transition_to("LadderDown")
		return

	if _can_jump():
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	if !_player.is_on_floor():
		if _can_plummet():
			_state_machine.transition_to("PrePlummet")
			return

	if Input.is_action_just_pressed("dash"):
		if _player.can_dash:
			_state_machine.transition_to("Dash")


func enter(_data: Dictionary = {}) -> void:
	if _player.is_on_floor():
		_player.recharge_dash_and_jumps()

	get_tree().create_timer(POST_DASH_PAUSE_DURATION).timeout.connect(
		_on_post_dash_pause_timer_timeout
	)


func _on_post_dash_pause_timer_timeout() -> void:
	if _state_machine.current_state != self:
		return

	if _player.is_on_floor():
		_state_machine.transition_to("Idle")
	else:
		_state_machine.transition_to("Airborne")
