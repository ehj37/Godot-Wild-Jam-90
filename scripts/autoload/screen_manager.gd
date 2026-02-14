extends Node

var current_screen: Screen
var is_initial_screen: bool = true


func _ready() -> void:
	SignalBus.screen_entered.connect(_on_screen_entered)


func _on_screen_entered(entered_screen: Screen) -> void:
	if current_screen != null:
		is_initial_screen = false

	current_screen = entered_screen
