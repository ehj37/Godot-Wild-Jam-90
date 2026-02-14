extends PlayerState

const AIRBORNE_COLOR: Color = Color.BLUE
const GRAVITY: float = 900.0
const AIRBORNE_MOVE_ACCELERATION: float = 150.0
const INITIAL_JUMP_SPEED: float = -225.0
const MIN_DIRECTIONAL_JUMP_SPEED_X: float = 0.75 * Player.MAX_MOVE_SPEED

var _velocity_x: float


func physics_update(delta: float) -> void:
	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	if Input.is_action_just_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	if !_player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			_state_machine.transition_to("PrePlummet")

		# Only change x component of velocity if there's player input.
		var input_direction: Vector2 = _player.get_input_direction()
		if !input_direction.is_zero_approx():
			_velocity_x = move_toward(
				_velocity_x,
				input_direction.x * Player.MAX_MOVE_SPEED,
				delta * AIRBORNE_MOVE_ACCELERATION
			)

		_player.velocity.x = _velocity_x

		_player.velocity.y += Player.GRAVITY * delta
		return

	if _player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Idle")
	else:
		_state_machine.transition_to("Run")


func enter(data: Dictionary = {}) -> void:
	_player.color_rect.color = AIRBORNE_COLOR
	if data.get("jump", false):
		var input_direction: Vector2 = _player.get_input_direction()
		if !input_direction.is_zero_approx():
			var jump_velocity_x_magnitude: float
			# Preserve speed if not a pivot jump, give half of max speed for a
			# pivot jump.
			if sign(input_direction.x) == sign(_player.velocity.x):
				jump_velocity_x_magnitude = max(
					abs(_player.velocity.x), MIN_DIRECTIONAL_JUMP_SPEED_X
				)
			else:
				jump_velocity_x_magnitude = MIN_DIRECTIONAL_JUMP_SPEED_X

			_velocity_x = sign(input_direction.x) * jump_velocity_x_magnitude
		else:
			_velocity_x = _player.velocity.x

		_player.velocity = Vector2(_velocity_x, INITIAL_JUMP_SPEED)
	else:
		_velocity_x = 0.0
