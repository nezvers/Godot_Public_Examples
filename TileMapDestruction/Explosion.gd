class_name Explosion

const size1: = [
	Vector2(0,0)
]
const size2: = [
	Vector2(1,	0),
	Vector2(-1,	0),
	Vector2(0,	1),
	Vector2(0,	-1)
]
const size3: = [
	Vector2(1,	1),
	Vector2(-1,	1),
	Vector2(1,	-1),
	Vector2(-1,	-1),
	Vector2(2,0),
	Vector2(-2,0),
	Vector2(0,2),
	Vector2(0,-2)
]
const size4: = [
	Vector2(0, -3),
	Vector2(-2, -2),
	Vector2(-1, -2),
	Vector2(1, -2),
	Vector2(2, -2),
	Vector2(-2, -1),
	Vector2(2, -1),
	Vector2(-3, 0),
	Vector2(3, 0),
	Vector2(0, 3),
	Vector2(-2, 2),
	Vector2(-1, 2),
	Vector2(1, 2),
	Vector2(2, 2),
	Vector2(-2, 1),
	Vector2(2, 1)
]

const shapes: = [
	size1,
	size2,
	size3,
	size4
]

# static function doesn't require instancing
static func trigger(map:TileMap, _position:Vector2)->void:
	var map_position: Vector2 = map.world_to_map(map.to_local(_position))
	for shape in shapes:
		for pos in shape:
			map.set_cellv(map_position + pos, -1)
		# Yields for animations
			#yield(map.get_tree().create_timer(0.008), "timeout")
		yield(map.get_tree().create_timer(0.08), "timeout")

# control animation and size from caller
static func trigger_shape(map:TileMap, _position:Vector2, i:int)->void:
	var map_position: Vector2 = map.world_to_map(map.to_local(_position))
	for pos in shapes[i % shapes.size()]:
			map.set_cellv(map_position + pos, -1)








