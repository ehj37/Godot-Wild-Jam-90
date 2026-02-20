extends Node2D

@onready var main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var settings_menu: VBoxContainer = $CenterContainer/SettingsMenu


func _on_start_button_pressed() -> void:
	LevelManager.go_to_first_level()


func _on_settings_button_pressed() -> void:
	main_buttons.visible = false
	settings_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	main_buttons.visible = true
	settings_menu.visible = false


func _on_main_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)
