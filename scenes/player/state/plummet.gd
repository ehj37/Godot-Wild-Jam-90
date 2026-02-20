extends PlayerState

const MIDAIR_PAUSE_TIME: float = 0.3
const PLUMMET_SPEED: float = 600.0

@onready
var player_ghost_packed_scene: PackedScene = preload("res://scenes/player/ghost/player_ghost.tscn")
@onready var plummet_ghost_timer: Timer = $PlummetGhostTimer


func update(_delta: float) -> void:
	if !_player.is_on_floor():
		_player.velocity.y = PLUMMET_SPEED
	else:
		_state_machine.transition_to("PostPlummet")


func enter(_data: Dictionary = {}) -> void:
	_player.set_collision_mask_value(8, false)
	_player.velocity = Vector2.ZERO
	_player.animation_player.play("plummet")

	plummet_ghost_timer.start()
	_add_plummet_ghost()


func exit() -> void:
	_player.set_collision_mask_value(8, true)

	plummet_ghost_timer.stop()
	_add_plummet_ghost()


func _add_plummet_ghost() -> void:
	var player_ghost: PlayerGhost = player_ghost_packed_scene.instantiate()
	player_ghost.ghost_variant = PlayerGhost.GhostVariant.PLUMMET
	player_ghost.global_position = _player.global_position
	player_ghost.flip_h = _player.sprite.flip_h
	ScreenManager.add_child(player_ghost)


func _on_plummet_ghost_timer_timeout() -> void:
	_add_plummet_ghost()
