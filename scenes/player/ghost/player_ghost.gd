class_name PlayerGhost

extends Sprite2D

enum GhostVariant { DASH, PLUMMET }

const GHOST_VARIANT_TO_ANIMATION: Dictionary = {
	GhostVariant.DASH: "dash_right", GhostVariant.PLUMMET: "plummet"
}

@export var ghost_variant: GhostVariant

@onready var animation_player: BulletTimeAnimationPlayer = $BulletTimeAnimationPlayer


func _ready() -> void:
	var animation_name: String = GHOST_VARIANT_TO_ANIMATION.get(ghost_variant)
	animation_player.play(animation_name)
	await animation_player.animation_finished

	queue_free()
