class_name ConcentricSquares

extends Node2D

signal square_added
signal stopped

@export var color: Color = Color.WHITE
@export var max_square_size: float = 100.0
@export var square_expand_duration: float = 4.0

@onready
var expanding_square_packed_scene: PackedScene = preload("./expanding_square/expanding_square.tscn")
@onready var square_timer: Timer = $SquareTimer


func stop() -> void:
	square_timer.stop()
	await get_tree().create_timer(square_expand_duration - square_timer.time_left).timeout

	stopped.emit()


func _on_square_timer_timeout() -> void:
	_emit_square()


func _emit_square() -> void:
	var new_square: ExpandingSquare = expanding_square_packed_scene.instantiate()
	new_square.color = color
	new_square.max_size = max_square_size
	new_square.expand_duration = square_expand_duration
	add_child(new_square)
	square_added.emit()
	new_square.finished.connect(func() -> void: new_square.queue_free())
