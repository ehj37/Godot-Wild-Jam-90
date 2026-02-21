extends PlayerState

const TIME_UNTIL_MOVEMENT_ALLOWED: float = 1.0

var _movement_allowed: bool = true


func physics_update(_delta: float) -> void:
	if _movement_allowed:
		if !_player.get_input_direction().is_zero_approx():
			_state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	_player.animation_player.play("big_land")
	SoundEffectManager.play_effect_for_screen(SoundEffectConfig.Type.LAND)
	get_tree().create_timer(TIME_UNTIL_MOVEMENT_ALLOWED).timeout.connect(
		func() -> void: _movement_allowed = true
	)
