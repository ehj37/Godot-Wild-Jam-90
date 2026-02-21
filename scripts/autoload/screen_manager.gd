extends Node

var current_screen: Screen
var _overlapping_screens: Array[Screen] = []


func _ready() -> void:
	SignalBus.screen_entered.connect(_on_screen_entered)
	SignalBus.screen_exited.connect(_on_screen_exited)


func _on_screen_entered(entered_screen: Screen) -> void:
	Map.update_progress(entered_screen, LevelManager.current_level)

	_overlapping_screens.append(entered_screen)
	current_screen = entered_screen
	SignalBus.snap_camera_to.emit(entered_screen, false)


func _on_screen_exited(exited_screen: Screen) -> void:
	_overlapping_screens.erase(exited_screen)

	if _overlapping_screens.is_empty():
		return

	var new_current_screen: Screen = _overlapping_screens.back()

	if current_screen == exited_screen:
		SignalBus.snap_camera_to.emit(new_current_screen, false)

	current_screen = _overlapping_screens.back()
