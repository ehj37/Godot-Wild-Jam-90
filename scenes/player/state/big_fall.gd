extends PlayerState

const TIME_UNTIL_FADE_OUT: float = 1.5


func physics_update(delta: float) -> void:
	_player.velocity.y = move_toward(
		_player.velocity.y, PlayerFallState.MAX_FALL_SPEED, delta * PlayerFallState.GRAVITY
	)

	if _player.is_on_floor():
		_state_machine.transition_to("BigLand")


func enter(data: Dictionary = {}) -> void:
	var transition_to_next_level: bool = data.get("transition_to_next_level", false)
	_player.velocity.x = 0
	_player.animation_player.play("big_fall")
	if transition_to_next_level:
		get_tree().create_timer(TIME_UNTIL_FADE_OUT).timeout.connect(
			func() -> void: LevelManager.go_to_next_level()
		)
