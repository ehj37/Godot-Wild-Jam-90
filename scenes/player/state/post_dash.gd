extends PlayerState

const POST_DASH_PAUSE_DURATION: float = 0.2


func update(_delta: float) -> void:
	_player.velocity = Vector2.ZERO

	if Input.is_action_just_pressed("jump") && _player.can_double_jump:
		_player.velocity.x = 0  # Why not, sure.
		_player.can_double_jump = false
		_state_machine.transition_to("Airborne", {"jump": true})  # Yech

	if Input.is_action_just_pressed("dash"):
		if _player.can_dash:
			_state_machine.transition_to("Dash")


func enter(_data: Dictionary = {}) -> void:
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
