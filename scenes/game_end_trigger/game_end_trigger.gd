extends Node2D


func _on_body_entered(player: Player) -> void:
	SignalBus.end_game.emit()
	player.process_mode = Node.PROCESS_MODE_DISABLED
