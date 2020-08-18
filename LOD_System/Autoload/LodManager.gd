extends Node2D

var x: = 0   #to be extra safe grid positions are integers.
var y: = 0
var last_x: = 0
var last_y: = 0
var grid_objects: = []  #1D Array holding nested Array for each cells instances.
var cell_size: = 8
var grid_width: = 20
var grid_height: = 20
var target:Node = null
var origin: = Vector2()


var blink: = 0
var blink_max: = 3
var draw_cells: = []

#LOD level positions
var LOD_1: = [
	Vector2( 0, 0),
	Vector2( 0, 1),
	Vector2( 0,-1),
	Vector2( 1, 0),
	Vector2(-1, 0),
	Vector2( 1, 1),
	Vector2(-1, 1),
	Vector2( 1,-1),
	Vector2(-1,-1)
]
var LOD_2: = [
	Vector2( 2, 0),
	Vector2(-2, 0),
	Vector2( 0, 2),
	Vector2( 0,-2),
	Vector2( 1, 2),
	Vector2( 1,-2),
	Vector2(-1,-2),
	Vector2(-1, 2),
	Vector2( 2, 1),
	Vector2( 2,-1),
	Vector2(-2, 1),
	Vector2(-2,-1)
]
var LOD_3: = [
	Vector2( 0, 3),
	Vector2( 0,-3),
	Vector2( 1, 3),
	Vector2( 1,-3),
	Vector2(-1, 3),
	Vector2(-1,-3),
	Vector2( 2, 2),
	Vector2( 2,-2),
	Vector2( 2, 3),
	Vector2( 2,-3),
	Vector2(-2, 2),
	Vector2(-2,-2),
	Vector2(-2, 3),
	Vector2(-2,-3),
	Vector2( 3, 0),
	Vector2(-3, 0),
	Vector2( 3, 1),
	Vector2( 3,-1),
	Vector2(-3, 1),
	Vector2(-3,-1),
	Vector2( 3, 2),
	Vector2( 3,-2),
	Vector2(-3, 2),
	Vector2(-3,-2)
]

var LOD_positions: = [LOD_1, LOD_2, LOD_3]


func set_target(_target:Spatial)->void:
	target = _target
	

func add_instance(inst:Spatial)->void:
	var _x: = int((inst.global_transform.origin.x-origin.x) / cell_size)
	var _y: = int((inst.global_transform.origin.z-origin.y) / cell_size)
	grid_objects[_x + _y*grid_width].append(inst)


func set_grid_size(_cell_size:int, map_pos:Vector2, map_size:Vector2)->void:	#map_pos should be maps most negative corner
	cell_size = _cell_size
	origin = map_pos
	grid_width = ceil(map_size.x / cell_size)
	grid_height = ceil(map_size.y / cell_size)
	for _y in grid_height:
		for _x in grid_width:
			grid_objects.append([])


func track_target()->bool:
	if target == null:
		return false
	x = int((target.global_transform.origin.x-origin.x) / cell_size)
	y = int((target.global_transform.origin.z-origin.y) / cell_size)
	return true


func _process(_delta:float)->void:
	if !track_target():
		return
	if x != last_x || y != last_y:
		LOD_update()
	last_x = x
	last_y = y


func LOD_update()->void:
	var target_pos: = Vector2(x, y)
	for i in LOD_positions.size():
		var lod_level = LOD_positions[i]
		for offset in lod_level:
			var pos:Vector2 = target_pos + offset
			var _x: = int(pos.x)
			var _y: = int(pos.y)
			if _x >= 0 && _x < grid_width && _y >= 0 && _y < grid_height:   #out of bounds check
				cell_update(grid_objects[_x + _y*grid_width], i)


func cell_update(cell:Array, LOD:int)->void: #sends back to instances to change LOD
	for inst in cell:
		inst.set_LOD(LOD)  #whatever way you tell the objects to change the LOD level


















