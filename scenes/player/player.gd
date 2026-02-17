class_name Player

extends CharacterBody2D

enum Orientation { RIGHT, LEFT }

const GRAVITY: float = 800.0
const MOVE_ACCELERATION: float = 500.0
const MOVE_DECELERATION: float = 700.0
const MAX_MOVE_SPEED: float = 90.0
const INITIAL_JUMP_SPEED: float = -225.0
const MOVE_LEFT: String = "move_left"
const MOVE_RIGHT: String = "move_right"
const BULLET_ABSORBING_STATES: Array[String] = ["Dash", "PostDash", "PrePlummet", "Plummet"]

@export var spawn_falling: bool = true

var jump_used: bool = false
var double_jump_used: bool = false

var can_dash: bool = true
var orientation: Player.Orientation = Orientation.RIGHT:
	set(value):
		match value:
			Player.Orientation.RIGHT:
				sprite.flip_h = false
				mantle_ray_cast_side_top.target_position.x = abs(
					mantle_ray_cast_side_top.target_position.x
				)
				mantle_ray_cast_side_bottom.target_position.x = abs(
					mantle_ray_cast_side_top.target_position.x
				)
				mantle_ray_cast_down.position.x = abs(mantle_ray_cast_down.position.x)
			Player.Orientation.LEFT:
				sprite.flip_h = true
				mantle_ray_cast_side_top.target_position.x = -abs(
					mantle_ray_cast_side_top.target_position.x
				)
				mantle_ray_cast_side_bottom.target_position.x = -abs(
					mantle_ray_cast_side_top.target_position.x
				)
				mantle_ray_cast_down.position.x = -abs(mantle_ray_cast_down.position.x)

		orientation = value

var _pressed_movement_inputs: Array[String] = []

@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_absorb_aureole: BulletAbsorbAureole = $BulletAbsorbAureole
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine_debug_label: Label = $StateMachineDebugLabel
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
# Ray casts
@onready var ladder_ray_cast_down: RayCast2D = $LadderRayCastDown
@onready var ladder_ray_cast_up: RayCast2D = $LadderRayCastUp
@onready var mantle_ray_cast_side_top: RayCast2D = $MantleRayCastSideTop
@onready var mantle_ray_cast_side_bottom: RayCast2D = $MantleRayCastSideBottom
@onready var mantle_ray_cast_down: RayCast2D = $MantleRayCastDown


func on_bullet_connect(bullet_type: Bullet.Type) -> void:
	# TODO: Transition to death if hit by a bullet when the state isn't dash or
	# post dash.

	var current_state_name: String = state_machine.current_state.name
	if current_state_name == "Hurt":
		return

	if !BULLET_ABSORBING_STATES.has(current_state_name) || bullet_type == Bullet.Type.DAMAGE:
		state_machine.transition_to("Hurt")
		return

	match bullet_type:
		Bullet.Type.EXTRA_DASH:
			can_dash = true
		Bullet.Type.STRENGTH:
			pass  # TODO
		Bullet.Type.RECHARGE_JUMP:
			recharge_jumps()

	bullet_absorb_aureole.flash(bullet_type)


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


func recharge_jumps() -> void:
	jump_used = false
	double_jump_used = false


func recharge_dash_and_jumps() -> void:
	recharge_jumps()
	can_dash = true


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("bullet_time"):
		if BulletTimeManager.in_bullet_time:
			SignalBus.bullet_time_exited.emit()
		else:
			SignalBus.bullet_time_entered.emit()

	_update_pressed_movement_inputs()
	move_and_slide()


func _ready() -> void:
	if spawn_falling:
		state_machine.initial_state = $StateMachine/BigFall


func _update_pressed_movement_inputs() -> void:
	for movement_input: String in [MOVE_RIGHT, MOVE_LEFT]:
		if Input.is_action_pressed(movement_input):
			if !_pressed_movement_inputs.has(movement_input):
				_pressed_movement_inputs.append(movement_input)
		else:
			_pressed_movement_inputs.erase(movement_input)


func _on_state_machine_state_entered(state_name: String) -> void:
	state_machine_debug_label.text = state_name


func _on_ability_chip_detection_area_body_entered(ability_chip: AbilityChip) -> void:
	state_machine.transition_to("AbilityGet", {"ability_chip": ability_chip})
