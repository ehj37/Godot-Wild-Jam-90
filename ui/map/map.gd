extends CanvasLayer

const FADE_IN_DURATION: float = 0.2
const FADE_OUT_DURATION: float = 0.1

var _fade_in_tween: Tween
var _fade_out_tween: Tween
var _level_1_pips: Array[MapProgressPip] = []
var _level_2_pips: Array[MapProgressPip] = []
var _level_3_pips: Array[MapProgressPip] = []

@onready var progress_pip_packed_scene: PackedScene = preload("./progress_pip/progress_pip.tscn")
@onready var container: Node2D = $Container
@onready var level_1_pip_container: HBoxContainer = $Container/Level1PipContainer
@onready var level_2_pip_container: HBoxContainer = $Container/Level2PipContainer
@onready var level_3_pip_container: HBoxContainer = $Container/Level3PipContainer


func update_progress(screen: Screen, level: Level) -> void:
	var progress_pips: Array[MapProgressPip]
	match level.name:
		"Level1":
			progress_pips = _level_1_pips
		"Level2":
			progress_pips = _level_2_pips
		"Level3":
			progress_pips = _level_3_pips

	var level_name: String = level.name
	var screen_name: String = screen.name
	var already_present: bool = (
		progress_pips.find_custom(
			func(p: MapProgressPip) -> bool: return (
				p.screen_name == screen_name && p.level_name == level_name
			)
		)
		!= -1
	)
	if already_present:
		return

	var new_pip: MapProgressPip = progress_pip_packed_scene.instantiate()
	new_pip.level_name = level_name
	new_pip.screen_name = screen_name

	match level.name:
		"Level1":
			level_1_pip_container.add_child(new_pip)
		"Level2":
			level_2_pip_container.add_child(new_pip)
		"Level3":
			level_3_pip_container.add_child(new_pip)

	progress_pips.append(new_pip)


func _show() -> void:
	if _fade_out_tween != null && _fade_out_tween.is_valid():
		_fade_out_tween.kill()

	_fade_in_tween = get_tree().create_tween()
	_fade_in_tween.tween_property(container, "modulate:a", 1.0, FADE_IN_DURATION)


func _hide() -> void:
	if _fade_in_tween != null && _fade_in_tween.is_valid():
		_fade_in_tween.kill()

	_fade_out_tween = get_tree().create_tween()
	_fade_out_tween.tween_property(container, "modulate:a", 0.0, FADE_OUT_DURATION)


func _ready() -> void:
	container.modulate.a = 0.0
	SignalBus.map_opened.connect(_show)
	SignalBus.map_closed.connect(_hide)
