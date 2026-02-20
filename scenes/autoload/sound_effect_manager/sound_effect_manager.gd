extends Node2D

const AUDIO_STREAM_PLAYER_MAX_DISTANCE: float = 200.0

@export var sound_effect_configs: Array[SoundEffectConfig]

var _sound_effect_configs: Dictionary = {}
var _audio_players_by_type: Dictionary = {}


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
		_audio_players_by_type[config.type] = []


func play_effect(type: SoundEffectConfig.Type, screen: Screen = null) -> void:
	if screen == null:
		screen = ScreenManager.current_screen

	var config: SoundEffectConfig = _sound_effect_configs.get(type)
	assert(config != null, "Sound effect must be defined in AudioManager")

	var audio_players_for_type: Array = _audio_players_by_type[type]
	var sound_effect_count: int = audio_players_for_type.size()
	if config.limit != -1 && sound_effect_count > config.limit:
		var oldest_audio_player: AudioStreamPlayer2D = audio_players_for_type.pop_front()
		oldest_audio_player.queue_free()

	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.max_distance = AUDIO_STREAM_PLAYER_MAX_DISTANCE
	audio_player.bus = "SFX"
	add_child(audio_player)
	audio_player.global_position = screen.center()
	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	audio_player.stream = audio_stream

	audio_player.finished.connect(func() -> void: audio_player.queue_free())
	audio_player.play()

	var audio_players: Array = _audio_players_by_type[type]
	audio_players.append(audio_player)
	audio_player.finished.connect(
		func() -> void: audio_players.erase(audio_player) ; audio_player.queue_free()
	)
