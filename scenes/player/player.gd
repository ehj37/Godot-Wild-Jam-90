class_name Player

extends CharacterBody2D

enum Orientation { RIGHT, LEFT }

const GRAVITY: float = 900.0
const MOVE_ACCELERATION: float = 500.0
const MOVE_DECELERATION: float = 700.0
const MAX_MOVE_SPEED: float = 80.0
const INITIAL_JUMP_SPEED: float = -225.0
const MOVE_LEFT: String = "move_left"
const MOVE_RIGHT: String = "move_right"

var orientation: Player.Orientation = Orientation.RIGHT
var _pressed_movement_inputs: Array[String] = []

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var ladder_ray_cast_down: RayCast2D = $LadderRayCastDown
@onready var ladder_ray_cast_up: RayCast2D = $LadderRayCastUp
@onready var state_machine_debug_label: Label = $StateMachineDebugLabel


func get_input_direction() -> Vector2:
	if _pressed_movement_inputs.is_empty():
		return Vector2.ZERO

	var most_recent_movement_input: String = _pressed_movement_inputs.back()
	match most_recent_movement_input:
		MOVE_RIGHT:
			return Vector2.RIGHT
		MOVE_LEFT:
			return Vector2.LEFT

	return Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("bullet_time"):
		if BulletTimeManager.in_bullet_time:
			SignalBus.bullet_time_exited.emit()
		else:
			SignalBus.bullet_time_entered.emit()

	_update_pressed_movement_inputs()
	move_and_slide()


func _update_pressed_movement_inputs() -> void:
	for movement_input: String in [MOVE_RIGHT, MOVE_LEFT]:
		if Input.is_action_pressed(movement_input):
			if !_pressed_movement_inputs.has(movement_input):
				_pressed_movement_inputs.append(movement_input)
		else:
			_pressed_movement_inputs.erase(movement_input)


func _on_state_machine_state_entered(state_name: String) -> void:
	state_machine_debug_label.text = state_name
