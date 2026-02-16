extends Node


func freeze_time() -> void:
	Engine.time_scale = 0.0


func unfreeze_time() -> void:
	Engine.time_scale = 1.0


func freeze_unfreeze_short() -> void:
	freeze_time()
	# Fourth param is ignore_time_scale
	await get_tree().create_timer(0.25, true, false, true).timeout

	unfreeze_time()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
