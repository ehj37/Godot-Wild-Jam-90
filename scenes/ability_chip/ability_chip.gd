class_name AbilityChip

extends Node2D

enum Ability { DOUBLE_JUMP, DASH, PLUMMET }

@export var ability: Ability

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var concentric_squares: ConcentricSquares = $ConcentricSquares


func grant_ability() -> void:
	match ability:
		Ability.DOUBLE_JUMP:
			AbilityManager.double_jump_unlocked = true
		Ability.DASH:
			AbilityManager.dash_unlocked = true
		Ability.PLUMMET:
			AbilityManager.plummet_unlocked = true
		_:
			assert("Cannot grant ability " + str(ability))


func kill() -> void:
	collision_shape.disabled = true
	color_rect.visible = false

	concentric_squares.stop()
	await concentric_squares.stopped

	queue_free()
