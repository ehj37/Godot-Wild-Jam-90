class_name PlayerState

extends State

var _player: Player


func _ready() -> void:
	await owner.ready

	_player = owner


func _can_jump() -> bool:
	if !Input.is_action_just_pressed("jump"):
		return false

	if !_player.jump_used:
		return true

	return AbilityManager.double_jump_unlocked && !_player.double_jump_used


func _can_dash() -> bool:
	return AbilityManager.dash_unlocked && Input.is_action_just_pressed("dash") && _player.can_dash


func _can_plummet() -> bool:
	return AbilityManager.plummet_unlocked && Input.is_action_just_pressed("plummet")


func _can_transition_to_ladder_up() -> bool:
	return (
		Input.is_action_pressed("climb_up")
		&& _player.ladder_ray_cast_up.is_colliding()
		&& _player.velocity.y >= 0.0
	)


func _can_transition_to_ladder_down() -> bool:
	return Input.is_action_pressed("climb_down") && _player.ladder_ray_cast_down.is_colliding()


func _ladder_jump_transition() -> void:
	if !_player.get_input_direction().is_zero_approx() || Input.is_action_pressed("climb_up"):
		_state_machine.transition_to("Airborne", {"jump": true})
		return

	_player.jump_used = true
	_state_machine.transition_to("Airborne")
