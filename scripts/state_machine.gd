class_name StateMachine

extends Node

signal state_entered(state_name: String)

@export var initial_state: State

var current_state: State
var _states: Array[State] = []


func transition_to(state_name: String, data: Dictionary = {}) -> void:
	var new_state_i: int = _states.find_custom(
		func(state: State) -> bool: return state.name == state_name
	)
	assert(new_state_i != -1, "Could not transition to state with name of " + state_name)

	current_state.exit()

	var new_state: State = _states[new_state_i]
	current_state = new_state
	state_entered.emit(new_state.name)
	new_state.enter(data)


func _ready() -> void:
	await owner.ready

	assert(initial_state != null, "Must set initial state")

	for child: State in get_children():
		_states.append(child)
		child._state_machine = self

	current_state = initial_state
	state_entered.emit(initial_state.name)
	initial_state.enter()


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)
