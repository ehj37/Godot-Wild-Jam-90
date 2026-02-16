extends PlayerState


func update(_delta: float) -> void:
	if !_player.animation_player.is_playing():
		_player.global_position = ScreenManager.current_screen.spawn_point.global_position
		_player.num_jumps = 0
		_state_machine.transition_to("Airborne")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	TimeScaleManager.freeze_unfreeze_short()
	_player.animation_player.play("hurt")
