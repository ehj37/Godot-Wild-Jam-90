extends Node2D

const AUDIO_STREAM_PLAYER_MAX_DISTANCE: float = 150.0

@export var sound_effect_configs: Array[SoundEffectConfig]

var _sound_effect_configs: Dictionary = {}
var _audio_players_by_screen: Dictionary = {}
var _type_by_audio_player: Dictionary = {}


func _ready() -> void:
	for sound_effect_type: SoundEffectConfig.Type in SoundEffectConfig.Type.values():
		var config_i: int = sound_effect_configs.find_custom(
			func(c: SoundEffectConfig) -> bool: return c.type == sound_effect_type
		)
		assert(
			config_i != -1,
			"Sound effect " + str(sound_effect_type) + " must be defined in SoundEffectManager"
		)

		var config: SoundEffectConfig = sound_effect_configs[config_i]
		_sound_effect_configs[config.type] = config


# Play a sound effect (not for a specific screen)
# Not respecting limits because ¯\_(ツ)_/¯
func play_effect(type: SoundEffectConfig.Type) -> void:
	var config: SoundEffectConfig = _sound_effect_configs.get(type)
	assert(config != null, "Sound effect must be defined in AudioManager")

	var new_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_audio_player.bus = "SFX"
	add_child(new_audio_player)
	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	new_audio_player.stream = audio_stream
	new_audio_player.play()

	new_audio_player.finished.connect(func() -> void: _free_audio_player_if_valid(new_audio_player))


# screen defaults to current screen
func play_effect_for_screen(type: SoundEffectConfig.Type, screen: Screen = null) -> void:
	if screen == null:
		screen = ScreenManager.current_screen

	if !is_instance_valid(screen):
		push_warning("Sound effect played for freed screen")
		return

	var config: SoundEffectConfig = _sound_effect_configs.get(type)
	assert(config != null, "Sound effect must be defined in AudioManager")

	var audio_players_for_screen: Array = _audio_players_by_screen.get(screen, [])
	var audio_players_for_type: Array = audio_players_for_screen.filter(
		func(ap: AudioStreamPlayer2D) -> bool: return _type_by_audio_player[ap] == type
	)

	var sound_effect_count: int = audio_players_for_type.size()
	if config.limit != -1 && sound_effect_count > config.limit:
		var oldest_audio_player: AudioStreamPlayer2D = audio_players_for_type.front()
		_remove_audio_player_from_screen(oldest_audio_player, screen)

	var new_audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	new_audio_player.max_distance = AUDIO_STREAM_PLAYER_MAX_DISTANCE
	new_audio_player.bus = "SFX"
	add_child(new_audio_player)
	new_audio_player.global_position = screen.center()
	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	new_audio_player.stream = audio_stream
	new_audio_player.play()

	if _audio_players_by_screen.get(screen) == null:
		_audio_players_by_screen[screen] = [new_audio_player]
	else:
		(_audio_players_by_screen[screen] as Array).append(new_audio_player)

	_type_by_audio_player[new_audio_player] = type

	new_audio_player.finished.connect(
		func() -> void: _remove_audio_player_from_screen(new_audio_player, screen)
	)


func _remove_audio_player_from_screen(audio_player: AudioStreamPlayer2D, screen: Screen) -> void:
	var audio_players_for_screen: Array = _audio_players_by_screen.get(screen, [])
	audio_players_for_screen.erase(audio_player)
	_type_by_audio_player.erase(audio_player)
	_free_audio_player_if_valid(audio_player)


func _free_audio_player_if_valid(audio_player: Node) -> void:
	if is_instance_valid(audio_player):
		audio_player.queue_free()
