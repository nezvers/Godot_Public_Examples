extends ColorRect



export (int) var handles: = 3 setget set_handles
func set_handles(value:int)->void:
# warning-ignore:narrowing_conversion
	handles = max(value, 2)
	set_positions()
	update()

#Resolution of the line
export (int) var resolution: = 5 setget set_resolution
func set_resolution(value:int)->void:
# warning-ignore:narrowing_conversion
	resolution = max(value, 2)
	update()


func _ready()->void:
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "mouse_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "mouse_exited")
	set_process(false)
	set_handles(handles)
	OS.center_window()

var hovering: = false
func mouse_entered()->void:
	set_process(true)
	hovering = true
	update()

func mouse_exited()->void:
	set_process(false)
	hovering = false
	update()

# Arbitrary rectangle padded and inverted Y direction
func get_area()->Rect2:
	var margin: = Vector2(10.0, 10.0)
	var size: = rect_size - margin * 2
	var origin: = rect_position + margin
	origin.y += size.y
	size.y *= -1
	return Rect2(origin, size)

# handle positions on the node
var positions: = []
func set_positions()->void:
	positions.clear()
	var rect: = get_area()
	var div:float = 1.0 / (handles-1)
	for j in handles:
		var p:Vector2 = rect.position + rect.size*(j*div)
		print(j)
		positions.append(p)

# find which is closest handle (-1 is none)
func get_closest_point(pos:Vector2)->int:
	var dist: = 30.0
	var index: = -1
	for i in range(1, positions.size()-1):
		var pDist:float = (pos - positions[i]).length()
		if pDist < dist:
			dist = pDist
			index = i
	return index

var closest:int = -1
var dragging: = false
func _process(_delta:float)->void:
	var mouse: = get_local_mouse_position()
	closest = get_closest_point(mouse)
	if closest > -1 && Input.is_mouse_button_pressed(1):
		dragging = true
	else:
		dragging = false
	
	if dragging:
		positions[closest].x = clamp(mouse.x,positions.front().x, positions.back().x)
		positions[closest].y = clamp(mouse.y,positions.back().y, positions.front().y)
	update()

# plot the bezier 
func get_bezier(arr:Array)->Array:
	if arr.empty():
		return []
	var bezier = []
	var div:float = 1.0 / resolution
	for i in resolution:
		var t:float = i*div
		bezier.append(bezier_interpolate(arr, t)[0])
	bezier.append(arr.back())
	return bezier

#recursive function that interpolates between lines down to last point
func bezier_interpolate(handlePoints:Array, t:float)->Array:
	var newHandles: = []
	for i in handlePoints.size()-1:
		var pos:Vector2 = handlePoints[i].linear_interpolate(handlePoints[i+1], t)
		newHandles.append(pos)
	if newHandles.size() == 1:
		return newHandles
	else:
		return bezier_interpolate(newHandles, t)

func _draw()->void:
	#draw points
	draw_handles(positions, closest, dragging, Color.white, Color.yellow)
	
	#draw bezier lines
	draw_bezier(positions, Color.green)

func draw_handles(arr:Array, dragIndex:int, isDragged:bool, col1:Color, col2:Color)->void:
	for i in arr.size():
		var pos:Vector2 = arr[i]
		var col: = col1
		var r: = 5.0
		if i == dragIndex:
			r = 10.0
			if isDragged:
				col = col2
		draw_arc(pos, r, 0.0, PI*2, 5, col)

func draw_bezier(arr:Array, col:Color)->void:
	var bezier:Array = get_bezier(arr)
	for i in bezier.size()-1:
		var p1:Vector2 = bezier[i]
		var p2:Vector2 = bezier[i+1]
		draw_line(p1,p2,col)





