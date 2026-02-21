class_name SoundEffectConfig

extends Resource

enum Type {
	JUMP, DASH, STEP, LAND, PLATFORM_BREAK, CANNON_FIRE, MAP_OPEN, JUMP_LAND, PLAYER_HURT, BIG_FALL
}
@export var type: Type
@export var limit: int = 1
@export var audio_stream: AudioStreamOggVorbis
