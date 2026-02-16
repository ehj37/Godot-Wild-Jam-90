class_name PlayerState

extends State

var _player: Player


func _ready() -> void:
	await owner.ready

	_player = owner


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

	_player.num_jumps = 1
	_state_machine.transition_to("Airborne")
