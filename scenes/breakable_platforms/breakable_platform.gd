extends StaticBody2D


func _on_player_detect_area_body_entered(_body: Player) -> void:
	queue_free()
