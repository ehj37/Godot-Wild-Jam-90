# Note: Not currently allowing for any mid-air strafing. May change.

extends PlayerState

const AIRBORNE_COLOR: Color = Color.BLUE
const GRAVITY: float = 900.0
const INITIAL_JUMP_SPEED: float = -225.0


func physics_update(delta: float) -> void:
	if !_player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			_state_machine.transition_to("PrePlummet")

		_player.velocity.y += Player.GRAVITY * delta
		return

	if _player.get_input_direction().is_zero_approx():
		_state_machine.transition_to("Idle")
	else:
		_state_machine.transition_to("Run")


func enter(data: Dictionary = {}) -> void:
	_player.color_rect.color = AIRBORNE_COLOR
	if data.get("jump", false):
		_player.velocity.y = INITIAL_JUMP_SPEED
