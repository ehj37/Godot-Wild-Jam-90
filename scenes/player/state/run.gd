extends PlayerState

const RUN_COLOR: Color = Color.GREEN
const NON_PIVOT_MOVE_ACCELERATION: float = 750.0
const PIVOT_MOVE_ACCELERATION: float = 1200.0
const MAX_MOVE_SPEED: float = 100.0


func physics_update(delta: float) -> void:
	var input_direction: Vector2 = _player.get_input_direction()

	if !input_direction.is_zero_approx():
		var move_acceleration: float
		if sign(_player.velocity.x) == sign(input_direction.x):
			move_acceleration = NON_PIVOT_MOVE_ACCELERATION
		else:
			move_acceleration = PIVOT_MOVE_ACCELERATION

		_player.velocity.x = move_toward(
			_player.velocity.x, input_direction.x * MAX_MOVE_SPEED, delta * move_acceleration
		)

	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	if input_direction.is_zero_approx():
		_state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_player.color_rect.color = RUN_COLOR
