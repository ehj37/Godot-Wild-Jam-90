extends Node


func freeze_time() -> void:
	Engine.time_scale = 0.0


func unfreeze_time() -> void:
	Engine.time_scale = 1.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
