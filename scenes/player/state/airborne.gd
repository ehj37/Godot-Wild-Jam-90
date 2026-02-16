extends PlayerState

const GRAVITY: float = 900.0
const MAX_FALL_SPEED: float = 500.0
const AIRBORNE_MOVE_ACCELERATION: float = 150.0
const INITIAL_JUMP_SPEED: float = -225.0
const MIN_DIRECTIONAL_JUMP_SPEED_X: float = 0.75 * Player.MAX_MOVE_SPEED

var _velocity_x: float


func physics_update(delta: float) -> void:
	var input_direction: Vector2 = _player.get_input_direction()
	# Only change x component of velocity if there's player input.
	if !input_direction.is_zero_approx():
		_velocity_x = move_toward(
			_velocity_x,
			input_direction.x * Player.MAX_MOVE_SPEED,
			delta * AIRBORNE_MOVE_ACCELERATION
		)

	_player.velocity.x = _velocity_x
	_player.velocity.y = move_toward(_player.velocity.y, MAX_FALL_SPEED, Player.GRAVITY * delta)

	# Update orientation
	if _player.velocity.x > 0:
		_player.orientation = Player.Orientation.RIGHT
	elif _player.velocity.x < 0:
		_player.orientation = Player.Orientation.LEFT
	else:
		# Fall back to input direction if velocity x is zero.
		# Player may be up against a wall and pressing a direction, in which
		# case velocity x is zero, but orientation x is nonzero.
		if input_direction.x > 0:
			_player.orientation = Player.Orientation.RIGHT
		elif input_direction.x < 0:
			_player.orientation = Player.Orientation.RIGHT

	if _player.is_on_floor():
		if _player.get_input_direction().is_zero_approx():
			_state_machine.transition_to("Idle")
		else:
			_state_machine.transition_to("Run")
		return

	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	if Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	if Input.is_action_just_pressed("plummet"):
		_state_machine.transition_to("PrePlummet")

	var bottom_ray_cast_colliding: bool = _player.mantle_ray_cast_side_bottom.is_colliding()
	var top_ray_cast_colliding: bool = _player.mantle_ray_cast_side_top.is_colliding()
	var is_corner_adjacent: bool = bottom_ray_cast_colliding && !top_ray_cast_colliding
	if is_corner_adjacent:
		var input_towards_corner: bool
		match _player.orientation:
			Player.Orientation.RIGHT:
				input_towards_corner = input_direction.x > 0
			Player.Orientation.LEFT:
				input_towards_corner = input_direction.x < 0

		if input_towards_corner:
			if !Input.is_action_pressed("jump") || _player.velocity.y > 0:
				_state_machine.transition_to("Mantle")


func enter(data: Dictionary = {}) -> void:
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
		_velocity_x = _player.velocity.x
