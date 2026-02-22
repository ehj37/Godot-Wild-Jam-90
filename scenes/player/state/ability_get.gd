extends PlayerState

const CELEBRATION_DURATION: float = 2.0
const CELEBRATION_RISE_HEIGHT: int = 5

var _ability_chip: AbilityChip


func enter(data: Dictionary = {}) -> void:
	_ability_chip = data.get("ability_chip")
	_player.z_index = 1000
	SignalBus.snap_and_zoom.emit(_player.global_position + Vector2(0, -10), 8)
	_player.velocity = Vector2.ZERO
	_player.animation_player.play("ability_get")
	SoundEffectManager.play_effect(SoundEffectConfig.Type.ABILITY_GET)
	var height_tween: Tween = get_tree().create_tween()
	var final_y: float = _player.global_position.y - CELEBRATION_RISE_HEIGHT
	height_tween.tween_property(_player, "global_position:y", final_y, CELEBRATION_DURATION)
	get_tree().create_timer(CELEBRATION_DURATION).timeout.connect(_on_celebration_timer_timeout)


func _on_celebration_timer_timeout() -> void:
	_state_machine.transition_to("Airborne")


func exit() -> void:
	_player.z_index = 0
	SignalBus.snap_camera_to.emit(ScreenManager.current_screen, true)
	_ability_chip.grant_ability()
	_ability_chip.kill()
