extends PlayerState

const MIDAIR_PAUSE_TIME: float = 0.25


func update(_delta: float) -> void:
	_player.velocity = Vector2.ZERO


func enter(_data: Dictionary = {}) -> void:
	_player.velocity = Vector2.ZERO
	get_tree().create_timer(MIDAIR_PAUSE_TIME).timeout.connect(_on_midair_pause_timer_timeout)
	_player.animation_player.play("pre_plummet")


func _on_midair_pause_timer_timeout() -> void:
	if _state_machine.current_state != self:
		return

	_state_machine.transition_to("Plummet")
