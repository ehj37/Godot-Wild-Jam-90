extends PlayerState

const MIDAIR_PAUSE_TIME: float = 0.3
const PLUMMET_SPEED: float = 800.0


func update(_delta: float) -> void:
	if !_player.is_on_floor():
		_player.velocity.y = PLUMMET_SPEED
	else:
		_state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_player.set_collision_mask_value(8, false)
	_player.velocity = Vector2.ZERO


func exit() -> void:
	_player.set_collision_mask_value(8, true)
