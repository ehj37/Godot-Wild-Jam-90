class_name TileMapUtils

extends Node


static func get_ladder_target_x(ray_cast: RayCast2D) -> float:
	var colliding_tile_map_layer: TileMapLayer = ray_cast.get_collider()
	print(ray_cast)
	var collision_point: Vector2 = ray_cast.get_collision_point()
	var collision_point_in_tile_map_local: Vector2 = colliding_tile_map_layer.to_local(
		collision_point
	)
	var map_position: Vector2i = colliding_tile_map_layer.local_to_map(
		collision_point_in_tile_map_local
	)

	var center_point_in_local: Vector2 = colliding_tile_map_layer.map_to_local(map_position)
	var center_point_in_global: Vector2 = colliding_tile_map_layer.to_global(center_point_in_local)
	return center_point_in_global.x
