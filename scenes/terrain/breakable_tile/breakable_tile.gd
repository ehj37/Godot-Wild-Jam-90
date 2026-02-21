@tool

extends StaticBody2D

enum TileVariant { CASTLE, DUNGEON, CAVES }

const TILE_VARIANT_TO_REGION_COORDS: Dictionary = {
	TileVariant.CASTLE: Vector2(64, 8),
	TileVariant.DUNGEON: Vector2(48, 72),
	TileVariant.CAVES: Vector2(128, 128)
}

@export var variant: TileVariant:
	set(new_value):
		variant = new_value
		if Engine.is_editor_hint():
			_update_sprite()

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_update_sprite()


func _update_sprite() -> void:
	sprite.region_rect.position = TILE_VARIANT_TO_REGION_COORDS[variant]


func _on_player_detect_area_body_entered(_player: Player) -> void:
	SoundEffectManager.play_effect_for_screen(SoundEffectConfig.Type.PLATFORM_BREAK)
	queue_free()
