extends PlayerState


func physics_update(_delta: float) -> void:
	if !_player.is_on_floor():
		_player.jump_used = true
		_state_machine.transition_to("Airborne")
		return

	if Input.is_action_just_pressed("map"):
		_state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	_player.animation_player.play("map_right")
	SoundEffectManager.play_effect_for_screen(SoundEffectConfig.Type.MAP_OPEN)
	SignalBus.map_opened.emit()


func exit() -> void:
	SoundEffectManager.play_effect_for_screen(SoundEffectConfig.Type.MAP_OPEN)
	SignalBus.map_closed.emit()
