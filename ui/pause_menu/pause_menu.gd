extends CanvasLayer

@onready var main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var settings_menu: VBoxContainer = $CenterContainer/SettingsMenu


func _ready() -> void:
	visible = false
	get_tree().paused = false


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		visible = !get_tree().paused
		get_tree().paused = !get_tree().paused


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_settings_button_pressed() -> void:
	main_buttons.visible = false
	settings_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	settings_menu.visible = false
	main_buttons.visible = true


func _on_main_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)
