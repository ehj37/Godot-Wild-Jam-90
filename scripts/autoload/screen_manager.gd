extends Node

var is_initial_screen: bool = true

var _screens: Array[Screen] = []
var _current_screen: Screen


func _ready() -> void:
	SignalBus.screen_entered.connect(_on_screen_entered)
	SignalBus.screen_exited.connect(_on_screen_exited)


func _on_screen_entered(entered_screen: Screen) -> void:
	if !_screens.is_empty() && is_initial_screen:
		is_initial_screen = false

	_screens.append(entered_screen)
	_current_screen = entered_screen
	SignalBus.snap_camera_to.emit(entered_screen)


func _on_screen_exited(exited_screen: Screen) -> void:
	_screens.erase(exited_screen)
	var new_current_screen: Screen = _screens.back()

	if _current_screen == exited_screen:
		SignalBus.snap_camera_to.emit(new_current_screen)

	_current_screen = _screens.back()
