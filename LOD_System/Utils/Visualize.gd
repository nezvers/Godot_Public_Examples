extends Node2D

var x: = 0   #to be extra safe grid positions are integers.
var y: = 0
var last_x: = 0
var last_y: = 0
var grid: = []      #1D Array for holding LOD level index.
var grid_objects: = []  #1D Array holding nested Array for each cells instances.
var cell_size: = 8
var grid_width: = 15
var grid_height: = 15
var target:Node = null


var blink: = 0
var blink_max: = 1
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


func _ready()->void:
	grid_update(cell_size, Vector2(grid_width*cell_size, grid_height*cell_size))
	LOD_update()

func track_target()->bool:
	var pos = get_local_mouse_position()
	x = int(pos.x/ cell_size)
	y = int(pos.y/ cell_size)
	return true
	
	if target == null:
		return false
	x = int(target.global_position.x)
	y = int(target.global_position.z)
	return true

func add_instance(inst:Node)->void:
	var _x: = int(inst.global_position.x)
	var _y: = int(inst.global_position.z)
	grid_objects[_x + _y*grid_width].append(inst)

func _process(delta:float)->void:
	if !track_target():
		return
	if x != last_x || y != last_y:
		LOD_update()
	
	last_x = x
	last_y = y
	
	#Just for 2D visualization
	if blink> 0:
		blink -= 1
	update() #call _draw()

func grid_update(_cell_size:int, map_size:Vector2)->void:
	cell_size = _cell_size
	grid_width = ceil(map_size.x / cell_size)
	grid_width = ceil(map_size.y / cell_size)
	grid.clear()
	for _y in grid_height:
		for _x in grid_width:
			grid.append(2)   #create enough slots
			grid_objects.append([])
	pass

func LOD_update()->void:
	print('LOD update: ', x, ' ', y)
	draw_cells.clear()
	var target_pos: = Vector2(x, y)
	for i in LOD_positions.size():
		var lod_level = LOD_positions[i]
		for offset in lod_level:
			var pos:Vector2 = target_pos + offset
			var _x: = int(pos.x)
			var _y: = int(pos.y)
			if _x >= 0 && _x < grid_width && _y >= 0 && _y < grid_height:   #out of bounds check
				grid[_x + _y*cell_size] = i
				cell_update(grid_objects[_x + _y*cell_size], i)
				draw_cells.append([Vector2(_x, _y), i])
	
	blink = blink_max   #Just for 2D visualization

func cell_update(cell:Array, LOD:int)->void: #sends back to instances to change LOD
	for inst in cell:
		inst.LOD = LOD  #whatever way you tell the objects to change the LOD level
	

#Just for 2D visualization
func _draw()->void:
	var lod_color: = [Color.red, Color.blue, Color.black]
	for A in draw_cells:
		var pos = A[0]
		var lod_level = grid[pos.x + pos.y*grid_width]
		var col:Color = lod_color[A[1]].linear_interpolate(Color.white, float(blink)/float(blink_max))
		var rect: = Rect2(Vector2(pos.x*cell_size, pos.y*cell_size), Vector2(cell_size, cell_size))
		draw_rect(rect, col, true, 0.0, false)
	#Draw grid
	for i in (grid_width +1):
		draw_line( Vector2(i*cell_size, 0.0), Vector2(i*cell_size, grid_height*cell_size), Color.white)
	for i in (grid_height +1):
		draw_line( Vector2(0.0, i*cell_size), Vector2(grid_width*cell_size, i*cell_size), Color.white)
	


















