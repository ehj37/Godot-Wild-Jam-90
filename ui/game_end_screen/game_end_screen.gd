extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SignalBus.end_game.connect(_on_game_end)


func _on_game_end() -> void:
	SoundEffectManager.play_effect(SoundEffectConfig.Type.GAME_END)
	animation_player.play("game_end")
