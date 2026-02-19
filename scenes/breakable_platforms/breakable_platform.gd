extends StaticBody2D


func _on_player_detect_area_body_entered(_body: Player) -> void:
	SoundEffectManager.play_effect(SoundEffectConfig.Type.PLATFORM_BREAK)
	queue_free()
