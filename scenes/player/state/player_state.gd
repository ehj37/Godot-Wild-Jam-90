class_name PlayerState

extends State

var _player: Player


func _ready() -> void:
	await owner.ready

	_player = owner
