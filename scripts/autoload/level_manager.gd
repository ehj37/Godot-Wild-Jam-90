extends Node

const POST_FADE_OUT_WAIT_TIME: float = 1.0
const ORDERED_LEVEL_PATHS: Array[String] = [
	"res://scenes/level_1.tscn", "res://scenes/level_2.tscn"
]

var current_level: Level


func go_to_next_level() -> void:
	var current_level_scene_file_path: String = current_level.scene_file_path
	var current_level_index: int = ORDERED_LEVEL_PATHS.find(current_level_scene_file_path)
	var new_level_scene_file_path: String = ORDERED_LEVEL_PATHS[current_level_index + 1]
	FadeRect.fade_out()
	await FadeRect.complete

	await get_tree().create_timer(POST_FADE_OUT_WAIT_TIME).timeout

	get_tree().change_scene_to_file(new_level_scene_file_path)
	await get_tree().scene_changed

	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED

	FadeRect.fade_in()
	await FadeRect.complete

	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT
