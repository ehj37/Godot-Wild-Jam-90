extends PlayerState

const POST_PLUMMET_DURATION: float = 0.25


func enter(_data: Dictionary = {}) -> void:
	_player.animation_player.play("post_plummet")
	get_tree().create_timer(POST_PLUMMET_DURATION).timeout.connect(_on_post_plummet_timer_timeout)


func _on_post_plummet_timer_timeout() -> void:
	if _state_machine.current_state != self:
		return

	_state_machine.transition_to("Idle")
