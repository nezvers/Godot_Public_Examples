class_name Explosion

var size1: = [
	Vector2(0,0)
]
var size2: = [
	Vector2(1,	0),
	Vector2(-1,	0),
	Vector2(0,	1),
	Vector2(0,	-1)
]
var size3: = [
	Vector2(1,	1),
	Vector2(-1,	1),
	Vector2(1,	-1),
	Vector2(-1,	-1),
	Vector2(2,0),
	Vector2(-2,0),
	Vector2(0,2),
	Vector2(0,-2)
]
var size4: = [
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

var shapes: = [
	size1,
	size2,
	size3,
	size4
]


func _init(map:TileMap, _position:Vector2)->void:
	var map_position: Vector2 = map.world_to_map(_position)
	for shape in shapes:
		for pos in shape:
			map.set_cellv(map_position + pos, -1)
		#yield(map.get_tree().create_timer(0.017), "timeout")









