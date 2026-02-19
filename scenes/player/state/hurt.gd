extends PlayerState


func update(_delta: float) -> void:
	if !_player.animation_player.is_playing():
		var spawn_point: Marker2D = ScreenManager.current_screen.spawn_point
		assert(spawn_point != null, "Can get hurt in level but no spawn point set.")
		_player.global_position = spawn_point.global_position
		_player.jump_used = true
		_player.double_jump_used = true
		_state_machine.transition_to("Airborne")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	SoundEffectManager.play_effect(SoundEffectConfig.Type.PLAYER_HURT)
	TimeScaleManager.freeze_unfreeze_short()
	_player.animation_player.play("hurt")
