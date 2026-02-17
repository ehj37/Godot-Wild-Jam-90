extends Area2D


func _on_body_entered(player: Player) -> void:
	# Yeah I know. Weird to be transitioning the player's state from an external scene.
	# If it works it works.
	player.state_machine.transition_to("BigFall", {"transition_to_next_level": true})
