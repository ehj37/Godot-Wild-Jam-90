class_name PlayerFallState

extends PlayerState

const GRAVITY: float = 900.0
const MAX_FALL_SPEED: float = 500.0
# The downward speed necessary for the player to switch from the jump animation
# to the fall animation
const FALL_ANIMATION_SPEED_THRESHOLD: float = 75.0
const AIRBORNE_MOVE_ACCELERATION: float = 850.0
const AIRBORNE_MOVE_DECELERATION: float = 250.0
const INITIAL_JUMP_SPEED: float = -225.0
const MIN_DIRECTIONAL_JUMP_SPEED_X: float = 0.75 * Player.MAX_MOVE_SPEED
const MANTLE_VELOCITY_Y_THRESHOLD: float = -40.0


func physics_update(delta: float) -> void:
	var input_direction: Vector2 = _player.get_input_direction()
	if !input_direction.is_zero_approx():
		_player.velocity.x = move_toward(
			_player.velocity.x,
			input_direction.x * Player.MAX_MOVE_SPEED,
			delta * AIRBORNE_MOVE_ACCELERATION
		)
	else:
		_player.velocity.x = move_toward(
			_player.velocity.x, 0.0, delta * AIRBORNE_MOVE_DECELERATION
		)

	_player.velocity.y = move_toward(_player.velocity.y, MAX_FALL_SPEED, Player.GRAVITY * delta)
	if _player.velocity.y <= FALL_ANIMATION_SPEED_THRESHOLD:
		_player.animation_player.play("jump_right")
	else:
		_player.animation_player.play("fall_right")

	if input_direction.x > 0:
		_player.orientation = Player.Orientation.RIGHT
	elif input_direction.x < 0:
		_player.orientation = Player.Orientation.LEFT

	if _can_jump():
		_apply_jump()
		return

	if _player.is_on_floor():
		SoundEffectManager.play_effect(SoundEffectConfig.Type.JUMP_LAND)

		if _player.get_input_direction().is_zero_approx():
			_state_machine.transition_to("Idle")
		else:
			_state_machine.transition_to("Run")
		return

	if _can_dash():
		_state_machine.transition_to("Dash")
		return

	if _can_transition_to_ladder_up():
		_state_machine.transition_to("LadderUp")
		return

	if _can_transition_to_ladder_down():
		_state_machine.transition_to("LadderDown")
		return

	if _can_plummet():
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
			if !Input.is_action_pressed("jump") || _player.velocity.y > MANTLE_VELOCITY_Y_THRESHOLD:
				_state_machine.transition_to("Mantle")


func enter(data: Dictionary = {}) -> void:
	if data.get("jump", false):
		_apply_jump()


func _apply_jump() -> void:
	SoundEffectManager.play_effect(SoundEffectConfig.Type.JUMP)

	# Trust that jump_used and double_jump_used are properly managed outside of
	# this state.
	if !_player.jump_used:
		_player.jump_used = true
	elif AbilityManager.double_jump_unlocked && !_player.double_jump_used:
		_player.double_jump_used = true
	else:
		assert(false, "Something has gone horribly wrong, can't jump but trying to.")

	var input_direction: Vector2 = _player.get_input_direction()
	if !input_direction.is_zero_approx():
		_player.velocity.x = sign(input_direction.x) * MIN_DIRECTIONAL_JUMP_SPEED_X
	else:
		_player.velocity.x = 0
	_player.velocity.y = INITIAL_JUMP_SPEED
