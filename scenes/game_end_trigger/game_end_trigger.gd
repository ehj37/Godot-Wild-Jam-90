extends Node2D

@onready var concentric_squares: ConcentricSquares = $ConcentricSquares


func _ready() -> void:
	concentric_squares.square_added.connect(_on_square_added)


func _on_square_added() -> void:
	SoundEffectManager.play_effect(SoundEffectConfig.Type.GAME_END_SQUARE_PULSE)


func _on_body_entered(player: Player) -> void:
	SignalBus.end_game.emit()
	player.process_mode = Node.PROCESS_MODE_DISABLED
