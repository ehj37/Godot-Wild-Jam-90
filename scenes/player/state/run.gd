extends PlayerState

const NON_PIVOT_MOVE_ACCELERATION: float = 650.0
const PIVOT_MOVE_ACCELERATION: float = 1800.0

var _in_coyote_time: bool = false

@onready var coyote_timer: Timer = $CoyoteTimer


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
		if !_in_coyote_time:
			coyote_timer.start()
			_in_coyote_time = true

		if coyote_timer.is_stopped():
			_player.num_jumps = 1
			_state_machine.transition_to("Airborne")
			return
	else:
		if _in_coyote_time:
			coyote_timer.stop()
			_in_coyote_time = false

	if Input.is_action_just_pressed("jump"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	var input_direction: Vector2 = _player.get_input_direction()
	if !input_direction.is_zero_approx():
		if input_direction.x > 0:
			_player.orientation = Player.Orientation.RIGHT
		else:
			_player.orientation = Player.Orientation.LEFT

		var move_acceleration: float
		if sign(_player.velocity.x) == sign(input_direction.x):
			move_acceleration = NON_PIVOT_MOVE_ACCELERATION
		else:
			move_acceleration = PIVOT_MOVE_ACCELERATION

		_player.velocity.x = move_toward(
			_player.velocity.x, input_direction.x * Player.MAX_MOVE_SPEED, delta * move_acceleration
		)

	if input_direction.is_zero_approx():
		_state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_player.animation_player.play("run_right")
	_in_coyote_time = false
	_player.recharge_dash_and_jump()
