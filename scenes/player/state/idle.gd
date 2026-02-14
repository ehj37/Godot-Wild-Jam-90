extends PlayerState

const IDLE_COLOR: Color = Color.RED


func physics_update(delta: float) -> void:
	if !_player.is_on_floor():
		_state_machine.transition_to("Airborne")
		return

	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	if !_player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Run")
		return

	# Necessary? Does this actually work?
	_player.velocity.x = move_toward(_player.velocity.x, 0, delta * Player.MOVE_DECELERATION)


func enter(_data: Dictionary = {}) -> void:
	_player.color_rect.color = IDLE_COLOR
