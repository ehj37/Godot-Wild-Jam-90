class_name ConcentricSquares

extends Node2D

signal stopped

@export var color: Color = Color.WHITE

@onready
var expanding_square_packed_scene: PackedScene = preload("./expanding_square/expanding_square.tscn")
@onready var square_timer: Timer = $SquareTimer


func stop() -> void:
	square_timer.stop()
	await get_tree().create_timer(ExpandingSquare.EXPAND_DURATION - square_timer.time_left).timeout

	stopped.emit()


func _on_square_timer_timeout() -> void:
	_emit_square()


func _emit_square() -> void:
	var new_square: ExpandingSquare = expanding_square_packed_scene.instantiate()
	new_square.color = color
	add_child(new_square)
	new_square.finished.connect(func() -> void: new_square.queue_free())
