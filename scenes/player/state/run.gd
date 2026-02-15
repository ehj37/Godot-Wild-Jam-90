extends PlayerState

const NON_PIVOT_MOVE_ACCELERATION: float = 650.0
const PIVOT_MOVE_ACCELERATION: float = 1200.0


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	if Input.is_action_just_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	if !_player.is_on_floor():
		_state_machine.transition_to("Airborne")
		return

	var input_direction: Vector2 = _player.get_input_direction()

	if !input_direction.is_zero_approx():
		var move_acceleration: float
		if sign(_player.velocity.x) == sign(input_direction.x):
			move_acceleration = NON_PIVOT_MOVE_ACCELERATION
		else:
			move_acceleration = PIVOT_MOVE_ACCELERATION

		_player.velocity.x = move_toward(
			_player.velocity.x, input_direction.x * Player.MAX_MOVE_SPEED, delta * move_acceleration
		)

	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	if input_direction.is_zero_approx():
		_state_machine.transition_to("Idle")
