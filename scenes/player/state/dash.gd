extends PlayerState

const DASH_SPEED: float = 500.0
const DASH_DURATION: float = 0.1

var _dash_direction: Vector2


func update(_delta: float) -> void:
	if _player.is_on_floor():
		_player.recharge_dash_and_jump()

	if Input.is_action_pressed("climb_up") && _player.ladder_ray_cast_up.is_colliding():
		_state_machine.transition_to("LadderUp")
		return

	if Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding():
		_state_machine.transition_to("LadderDown")
		return

	if Input.is_action_just_pressed("plummet"):
		_state_machine.transition_to("PrePlummet")
		return

	_player.velocity = _dash_direction * DASH_SPEED


func enter(_data: Dictionary = {}) -> void:
	_player.can_dash = false

	var input_direction: Vector2 = _player.get_input_direction()
	if !input_direction.is_zero_approx():
		if input_direction.x > 0:
			_player.orientation = Player.Orientation.RIGHT
		else:
			_player.orientation = Player.Orientation.LEFT

	match _player.orientation:
		Player.Orientation.RIGHT:
			_dash_direction = Vector2.RIGHT
		Player.Orientation.LEFT:
			_dash_direction = Vector2.LEFT

	_player.velocity = _dash_direction * DASH_SPEED
	get_tree().create_timer(DASH_DURATION).timeout.connect(_on_dash_timer_timeout)


func _on_dash_timer_timeout() -> void:
	if _state_machine.current_state != self:
		return

	_player.velocity = Vector2.ZERO
	_state_machine.transition_to("PostDash")
